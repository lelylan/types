require 'spec_helper'

describe Device do

  let(:resource) { FactoryGirl.create :device }

  it 'connects to devices database' do
    Device.database_name.should == 'devices_test'
  end

  it 'creates a resource' do
    resource.id.should_not be_nil
  end
end
