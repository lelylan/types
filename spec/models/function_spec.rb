require 'spec_helper'

describe Function do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  context 'when creates function properties' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { id: status.id, expected: 'on' },
      { id: intensity.id, expected: '0.0' }
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

    context 'with not valid property id' do

      let(:properties) { [{ id: nil, expected: 'value' }] }
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

  describe 'when connected to a type' do

    let!(:function) { FactoryGirl.create(:function) }
    let!(:type)     { FactoryGirl.create :type, function_ids: [function.id ] }

    describe 'when the function is destroyed' do

      before { function.destroy }
      before { type.reload }

      it 'removes the property from the type' do
        type.function_ids.should be_empty
      end
    end
  end
end

