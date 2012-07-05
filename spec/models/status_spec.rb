require 'spec_helper'

describe Status do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:created_from)} }


  describe "#create_status_properties" do

    context "with valid properties" do

      let(:properties) { json_fixture('status_properties.json')[:properties] }
      let(:status)     { FactoryGirl.create(:status_no_connections, properties: properties) }
      subject          { status.status_properties }

      it "creates properties" do
        subject.should have(2).items
      end

      it "sets the status" do
        subject.where(property_id: 'status').first.values.should == ['on']
      end

      it "sets the intensity" do
        subject.where(property_id: 'intensity').first.range_start.should == '75'
        subject.where(property_id: 'intensity').first.range_end.should == '100'
      end
    end

    context "with pre-existing properties" do

      let(:properties) { json_fixture('status_properties.json')[:properties] }
      let(:status)     { FactoryGirl.create(:setting_intensity, properties: properties) }
      subject          { status.status_properties }

      it "deletes previous properties" do
        subject.should have(2).items
      end

      it "sets the new status" do
        subject.where(property_id: 'status').first.values.should == ['on']
      end

      it "sets the new intensity" do
        subject.where(property_id: 'intensity').first.range_start.should == '75'
        subject.where(property_id: 'intensity').first.range_end.should == '100'
      end
    end

    #context "with not valid URI" do

      #it "does not create the property" do
        #expect { 
          #FactoryGirl.create(:function_no_connections, properties: [{ }]) 
        #}.to raise_error(Lelylan::Errors::ValidURI)
      #end
    #end

    #context "with duplicated properties" do

      #let(:properties) { json_fixture('properties.json')[:properties] }
      #before           { properties[1] = properties[0] }

      #it "does not create the property twice" do
        #expect { 
          #FactoryGirl.create(:function, properties: properties) 
        #}.to raise_error(Mongoid::Errors::Validations)
      #end
    #end

    #context "with no properties" do

      #let(:function) { FactoryGirl.create(:function) }
      #subject        { function.function_properties }

      #it "should not change anything" do
        #subject.should have(2).items
      #end
    #end

    #context "with empty properties" do

      #let(:function) { FactoryGirl.create(:function, properties: []) }
      #subject        { function.function_properties }

      #it "removes all properties" do
        #subject.should have(0).items
      #end
    #end

    #context "with not valid JSON" do

      #it "should raise an error" do
        #expect { 
          #FactoryGirl.create(:function, properties: "string") 
        #}.to raise_error
      #end
    #end
  end
end
