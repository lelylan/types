require 'spec_helper'

describe FunctionProperty do

  it { should allow_value(nil).for('value') }

  it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:uri)} }
  it { Settings.validation.uris.not_valid.each {|uri| should_not allow_value(uri).for(:uri)} }

  context "with valid uri" do

    let(:properties) { json_fixture('function_properties.json')[:properties] }
    let(:function)   { FactoryGirl.create(:function, properties: properties); }

    context "#status" do

      subject { function.properties.first }

      it "sets the property_id" do
        subject.property_id.should == 'status'
      end

      it "sets the value" do
        subject.value.should == 'on'
      end
    end

    context "#intensity" do

      subject { function.properties.last }

      it "sets the property_id" do
        subject.property_id.should == 'intensity'
      end

      it "sets the value" do
        subject.value.should == '0.0'
      end
    end
  end
end
