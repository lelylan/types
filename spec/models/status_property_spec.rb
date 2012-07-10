require 'spec_helper'

describe StatusProperty do

  it { should validate_presence_of(:uri) }
  it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:uri)} }
  it { Settings.validation.uris.not_valid.each {|uri| should_not allow_value(uri).for(:uri)} }

  context "with valid uri" do

    let(:properties) { json_fixture('status_properties.json')[:properties] }
    let(:status)     { FactoryGirl.create(:setting_intensity, properties: properties); }

    context "#status property" do

      subject { status.properties.first }

      it "sets the property_id" do
        subject.property_id.should == 'status'
      end

      it "sets the value" do
        subject.values.should == ['on']
      end
    end

    context "#intensity" do

      subject { status.properties.last }

      it "sets the property_id" do
        subject.property_id.should == 'intensity'
      end

      it "sets the range" do
        subject.range_start.should == '75'
        subject.range_end.should == '100'
      end
    end
  end
end
