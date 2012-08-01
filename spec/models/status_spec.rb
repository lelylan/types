require 'spec_helper'

describe Status do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  it_behaves_like 'a boolean' do
    let(:field)       { 'pending' }
    let(:accepts_nil) { true }
    let(:resource)    { FactoryGirl.create :setting_intensity }
  end

  context 'when creates function properties' do

    let(:properties) {[
      { uri: 'https://api.lelylan.com/properties/status', pending: false , values: ['on'] },
      { uri: 'https://api.lelylan.com/properties/intensity', pending: true, min_range: '75', max_range: '100' }
    ]}

    context 'with valid properties' do

      let(:status) { FactoryGirl.create :setting_intensity, :with_no_properties, properties: properties }

      it 'creates properties' do
        status.properties.should have(2).items
      end
    end

    context 'with pre-existing properties' do

      let(:status)         { FactoryGirl.create :setting_intensity }
      let!(:old_stauts)    { status.properties.where(property_id: 'status').first }
      let!(:old_intensity) { status.properties.where(property_id: 'intensity').first }

      before               { status.update_attributes properties: properties }
      let!(:new_stauts)    { status.properties.where(property_id: 'status').first }
      let!(:new_intensity) { status.properties.where(property_id: 'intensity').first }

      it 'replaces previous properties' do
        new_stauts.id.should_not    == old_stauts.id
        new_intensity.id.should_not == old_intensity.id
      end
    end

    context 'with empty properties' do

      let(:status) { FactoryGirl.create :setting_intensity, properties: [] }

      it 'removes previous properties' do
        status.properties.should have(0).items
      end
    end

    context 'with no properties' do

      let(:status) { FactoryGirl.create :function }
      before       { status.update_attributes {} }

      it 'does not change anything' do
        status.properties.should have(2).items
      end
    end

    context 'with not valid property uri' do

      let(:properties) { [{uri: 'not-valid', value: 'value'}] }
      let(:status)     { FactoryGirl.create :setting_intensity, properties: properties, name: 'Status' }

      it 'raises an error' do
        expect { status }.to raise_error Mongoid::Errors::Validations
      end
    end

    context 'with not valid json' do

      let(:status) { FactoryGirl.create(:status, properties: 'not-valid') }

      it 'raises an error' do
        expect { status }.to raise_error
      end
    end
  end
end
