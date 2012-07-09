require 'spec_helper'

describe FunctionProperty do

  it { should allow_value(nil).for('value') }

  it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:property_uri)} }
  it { Settings.validation.uris.not_valid.each {|uri| should_not allow_value(uri).for(:property_uri)} }

  context "with valid property_uri" do

    let(:function_property) { { property_uri: Settings.properties.status.uri, value: 'on' } }
    let(:function)          { FactoryGirl.create(:function_no_connections) }

    before  { function.function_properties.create!(function_property) }
    subject { function.function_properties.first }

    it "sets the property_id" do
      subject.property_id.should == Settings.properties.status.property_id
    end
  end

  context "with duplicated property_uri" do

    let(:function_property) { { property_uri: Settings.properties.status.uri, value: 'on' } }
    let(:function)          { FactoryGirl.create(:function_no_connections) }

    before  { function.function_properties.create!(function_property) }
    subject { function.function_properties }

    it "raises a validation error" do
      expect { subject.create!(function_property) }.to raise_error(Mongoid::Errors::Validations)
    end
  end
end
