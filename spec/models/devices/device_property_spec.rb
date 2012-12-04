require 'spec_helper'

describe DeviceProperty do

  let(:resource) { FactoryGirl.create(:device).properties.first }

  it 'connects to devices database' do
    Device.database_name.should == 'devices_test'
  end

  it 'creates a resource' do
    resource.id.should_not be_nil
  end

  it 'sets the id to the same value of property_id' do
    resource.id.should == resource.property_id
  end
end
