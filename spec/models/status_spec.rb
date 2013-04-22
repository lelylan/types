require 'spec_helper'

describe Status do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  describe 'when sets the defualt function' do

    let(:function) { FactoryGirl.create(:function) }
    let(:status)   { FactoryGirl.create(:setting_intensity, function: { id: function.id }) }

    it 'sets the function_id field' do
      status.function_id = function.id
    end
  end

  describe 'when does not set the defualt function' do

    let(:status)   { FactoryGirl.create(:setting_intensity) }

    it 'leave the function_id field to nil' do
      status.function_id = nil
    end
  end

  context 'when creates status properties' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { id: status.id, matches: ['on'] },
      { id: intensity.id, matches: ['75..100'] }
    ]}

    context 'with valid properties' do

      let(:resource) { FactoryGirl.create :setting_intensity, properties: properties }

      it 'creates properties' do
        resource.properties.should have(2).items
      end
    end

    context 'with pre-existing properties' do

      let(:resource)       { FactoryGirl.create :setting_intensity }
      let!(:old_stauts)    { resource.properties.first }
      let!(:old_intensity) { resource.properties.last }

      before               { resource.update_attributes properties: properties }
      let!(:new_stauts)    { resource.properties.first }
      let!(:new_intensity) { resource.properties.last }

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

    context 'with not valid property id' do

      let(:properties) { [{ id: nil, values: 'value' }] }
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

  describe 'when connected to a type' do

    let!(:status) { FactoryGirl.create(:setting_intensity) }
    let!(:type)   { FactoryGirl.create :type, status_ids: [status.id ] }

    describe 'when the status is destroyed' do

      before { status.destroy }
      before { type.reload }

      it 'removes the status from the type' do
        type.status_ids.should be_empty
      end
    end
  end
end
