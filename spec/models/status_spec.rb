require 'spec_helper'

describe Status do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  it_behaves_like 'a boolean' do
    let(:field)       { 'pending' }
    let(:accepts_nil) { true }
    let(:resource)    { FactoryGirl.create :setting_intensity }
  end

  context 'when creates status properties' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { uri: a_uri(status), values: ['on'] },
      { uri: a_uri(intensity),  min_range: '75', max_range: '100' }
    ]}

    context 'with valid properties' do

      let(:resource) { FactoryGirl.create :setting_intensity, :with_no_properties, properties: properties }

      it 'creates properties' do
        resource.properties.should have(2).items
      end
    end

    context 'with pre-existing properties' do

      let(:resource)       { FactoryGirl.create :setting_intensity }
      let!(:old_stauts)    { resource.properties.where(property_id: 'status').first }
      let!(:old_intensity) { resource.properties.where(property_id: 'intensity').first }

      before               { resource.update_attributes properties: properties }
      let!(:new_stauts)    { resource.properties.where(property_id: status.id).first }
      let!(:new_intensity) { resource.properties.where(property_id: intensity.id).first }

      it 'replaces previous properties' do
        new_stauts.id.should_not    == old_stauts.id
        new_intensity.id.should_not == old_intensity.id
      end
    end

    context 'with empty properties' do

      let(:resource) { FactoryGirl.create :setting_intensity, properties: [] }

      it 'removes previous properties' do
        resource.properties.should have(0).items
      end
    end

    context 'with no properties' do

      let(:resource) { FactoryGirl.create :setting_intensity }
      before         { resource.update_attributes {} }

      it 'does not change anything' do
        resource.properties.should have(2).items
      end
    end

    context 'with not valid property uri' do

      let(:properties) { [{uri: 'not-valid', value: 'value'}] }
      let(:resource)   { FactoryGirl.create :setting_intensity, properties: properties, name: 'Status' }

      it 'raises an error' do
        expect { resource }.to raise_error Mongoid::Errors::Validations
      end
    end

    context 'with not valid json' do

      let(:resource) { FactoryGirl.create(:status, properties: 'not-valid') }

      it 'raises an error' do
        expect { resource }.to raise_error
      end
    end
  end
end
