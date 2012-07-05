require 'spec_helper'

describe Function do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:created_from)} }


  describe "#create_function_properties" do

    context "with valid properties" do

      let(:properties) { json_fixture('properties.json')[:properties] }
      let(:function)   { FactoryGirl.create(:function_no_connections, properties: properties) }
      subject          { function.function_properties }

      it "creates properties" do
        subject.should have(2).items
      end

      it "sets the status" do
        subject.where(property_id: 'status').first.value.should == 'on'
      end

      it "sets the intensity" do
        subject.where(property_id: 'intensity').first.value.should == '100.0'
      end
    end

    context "with existing properties" do
      let(:properties) { json_fixture('properties.json')[:properties] }
      let(:function)   { FactoryGirl.create(:function, properties: properties) }
      subject          { function.function_properties }

      it "deletes previous ones" do
        subject.should have(2).items
      end

      it "sets the new status" do
        subject.where(property_id: 'status').first.value.should == 'on'
      end

      it "sets the new intensity" do
        subject.where(property_id: 'intensity').first.value.should == '100.0'
      end
    end

    context "with not valid properties" do
      it "does not create properties" do
        expect {
          FactoryGirl.create(:function_no_connections, properties: [{value: 'base'}])
        }.to raise_error(Mongoid::Errors::Validations)
      end
    end

    context "with no properties" do
      it "should not change anything" do
      end
    end

    context "with duplicate the property" do
      it "does not create the property" do
      end
    end

    context "with not valid JSON" do
      it "should raise an error" do
      end
    end

    # case sends a uri malformed in the properties
  end
end

#describe "#create_function_properties" do
#context "when valid" do
#before  { @properties = [{ uri: Settings.properties.status.uri, value: 'on' }] }
#subject { Factory(:function, properties: @properties).function_properties }
#it { should have(1).item }
#end


#context "when not valid" do
#before do 
#@message    = "Validation failed - Filter is not included in the list."
#@properties = [
#{ uri: Settings.properties.status.uri, value: 'off', filter: 'not valid'},
#{ uri: Settings.properties.intensity.uri, value: '10.0', filter: 'second not valid'} ]
#end

#it "should get a not valid notification" do
#lambda{ Factory(:function, properties: @properties) }.
#should raise_error(Mongoid::Errors::Validations)
#end

#it "should get notification based on the first not valid connection" do
#lambda{ Factory(:function, properties: @properties) }.
#should raise_error(Mongoid::Errors::Validations, @message)
#end
#end


#context "when has duplicated property URI" do
#before do
#@message = "A resource can not be connected more than once"
#@properties = [
#{ uri: Settings.properties.status.uri, value: 'on' },
#{ uri: Settings.properties.status.uri, value: 'off'} ]
#end

#it "should get a not valid notification" do
#lambda{ Factory(:function, properties: @properties) }.
#should raise_error(Mongoid::Errors::Duplicated, @message)
#end
#end

#context "with not owned properties" do
#end

#context "with not existng property" do
#end

#end
