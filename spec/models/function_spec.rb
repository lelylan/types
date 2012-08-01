require 'spec_helper'

describe Function do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  context 'when creates function properties' do

    let(:properties) {[
      { uri: 'https://api.lelylan.com/properties/status',    value: 'on' },
      { uri: 'https://api.lelylan.com/properties/intensity', value: '0.0' }
    ]}

    context 'with valid properties' do

      let(:function) { FactoryGirl.create :function, :with_no_properties, properties: properties }

      it 'creates two properties' do
        function.properties.should have(2).items
      end
    end

    context 'with pre-existing properties' do

      let(:function)       { FactoryGirl.create :function }
      let!(:old_stauts)    { function.properties.where(property_id: 'status').first }
      let!(:old_intensity) { function.properties.where(property_id: 'intensity').first }

      before               { function.update_attributes properties: properties }
      let!(:new_stauts)    { function.properties.where(property_id: 'status').first }
      let!(:new_intensity) { function.properties.where(property_id: 'intensity').first }

      it 'replaces previous properties' do
        new_stauts.id.should_not    == old_stauts.id
        new_intensity.id.should_not == old_intensity.id
      end
    end

    context 'with empty properties' do

      let(:function) { FactoryGirl.create :function, properties: [] }

      it 'removes previous properties' do
        function.properties.should have(0).items
      end
    end

    context 'with no properties' do

      let(:function) { FactoryGirl.create :function }
      before         { function.update_attributes {} }

      it 'does not change anything' do
        function.properties.should have(2).items
      end
    end

    context 'with not valid property uri' do

      let(:properties) { [{uri: 'not-valid', value: 'value'}] }
      let(:function)   { FactoryGirl.create :function, properties: properties, name: 'Function' }

      it 'raises an error' do
        expect { function }.to raise_error Mongoid::Errors::Validations
      end
    end

    context 'with not valid json' do

      let(:function) { FactoryGirl.create(:function, properties: 'not-valid') }

      it 'raises an error' do
        expect { function }.to raise_error
      end
    end
  end
end

