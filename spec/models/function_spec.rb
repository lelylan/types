require 'spec_helper'

describe Function do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  context 'when creates function properties' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { uri: a_uri(status), value: 'on' },
      { uri: a_uri(intensity), value: '0.0' }
    ]}

    context 'with valid properties' do

      let(:resource) { FactoryGirl.create :function, :with_no_properties, properties: properties }

      it 'creates two properties' do
        resource.properties.should have(2).items
      end
    end

    context 'with pre-existing properties' do

      let(:resource)       { FactoryGirl.create :function }
      let!(:old_status)    { resource.properties.first }
      let!(:old_intensity) { resource.properties.last }

      before               { resource.update_attributes properties: properties }
      let!(:new_status)    { resource.properties.first }
      let!(:new_intensity) { resource.properties.last }

      it 'replaces previous properties' do
        new_status.id.should_not    == old_status.id
        new_intensity.id.should_not == old_intensity.id
      end
    end

    context 'with empty properties' do

      let(:resource) { FactoryGirl.create :function, properties: [] }

      it 'removes previous properties' do
        resource.properties.should have(0).items
      end
    end

    context 'with no properties' do

      let(:resource) { FactoryGirl.create :function }
      before         { resource.update_attributes name: 'Updated' }

      it 'does not change anything' do
        resource.properties.should have(2).items
      end
    end

    context 'with not valid property uri' do

      let(:properties) { [{uri: 'not-valid', value: 'value'}] }
      let(:resource)   { FactoryGirl.create :function, properties: properties, name: 'Function' }

      it 'raises an error' do
        expect { resource }.to raise_error Mongoid::Errors::Validations
      end
    end

    context 'with not valid json' do

      let(:resource) { FactoryGirl.create(:function, properties: 'not-valid') }

      it 'raises an error' do
        expect { resource }.to raise_error
      end
    end
  end
end

