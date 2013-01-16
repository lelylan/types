require 'spec_helper'
require 'sidekiq/testing/inline'

describe Property do

  it { should_not allow_mass_assignment_of :resource_owner_id }

  it { should validate_presence_of :resource_owner_id }
  it { should validate_presence_of :name }


  describe 'when connected to a function' do

    let!(:function_property) { FactoryGirl.build(:status_for_function) }
    let!(:function)          { FactoryGirl.create :function, properties: [ function_property ] }

    describe 'when the property is destroyed' do

      before { Property.find(function_property.property_id).destroy }
      before { function.reload }

      it 'removes the property from the function' do
        function.properties.should be_empty
      end
    end
  end

  describe 'when connected to a status' do

    let!(:status_property) { FactoryGirl.build(:status_for_status) }
    let!(:status)          { FactoryGirl.create :setting_intensity, properties: [ status_property ] }

    describe 'when the property is destroyed' do

      before { Property.find(status_property.property_id).destroy }
      before { status.reload }

      it 'removes the property from the status' do
        status.properties.should be_empty
      end
    end
  end

  describe 'when connected to a type' do

    let!(:property) { FactoryGirl.create(:status) }
    let!(:type)     { FactoryGirl.create :type, property_ids: [ property.id ] }

    let!(:device_status) { FactoryGirl.build(:device_status, property_id: property.id) }
    let!(:device)        { FactoryGirl.create :device, type_id: type.id, properties: [device_status] }

    describe 'when the property is destroyed' do

      before { property.destroy }
      before { type.reload }

      it 'removes the property from the type' do
        type.property_ids.should be_empty
      end

      describe 'when the type worker runs' do

        before { device.reload }

        it 'removes the property from the device' do
          device.properties
        end
      end
    end
  end
end
