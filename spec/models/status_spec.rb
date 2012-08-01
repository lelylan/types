#require "spec_helper"

#describe Status do

  #it { should validate_presence_of(:name) }
  #it { should validate_presence_of(:created_from) }

  #it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:created_from)} }
  #it { Settings.validation.uris.not_valid.each {|uri| should_not allow_value(uri).for(:created_from)} }

  #context "#pending" do
    #it { [true, false, nil].each { |value| should allow_value(value).for(:pending) } }
    #it_validates "boolean", "pending", FactoryGirl.create(:setting_intensity)
  #end


  #describe "#create_status_properties" do

    #context "with valid properties" do

      #let(:properties) { json_fixture("status_properties.json")[:properties] }
      #let(:status)     { FactoryGirl.create(:setting_intensity_no_connections, properties: properties) }
      #subject          { status.properties }

      #it "creates properties" do
        #subject.should have(2).items
      #end

      #it "sets the status" do
        #subject.where(property_id: "status").first.values.should == ["on"]
      #end

      #it "sets the intensity start range" do
        #subject.where(property_id: "intensity").first.range_start.should == "75"
      #end

      #it "sets the intensity end range" do
        #subject.where(property_id: "intensity").first.range_end.should == "100"
      #end
    #end

    #context "with pre-existing properties" do

      #let(:properties) { json_fixture("status_properties.json")[:properties] }
      #let(:status)     { FactoryGirl.create(:setting_intensity) }
      #before           { status.update_attributes(properties: properties) }
      #subject          { status.properties }

      #it "deletes previous properties" do
        #subject.should have(2).items
      #end
    #end

    #context "with not valid params" do

      #context "when name is missing" do
        #it "raises an error" do
          #expect { FactoryGirl.create(:setting_intensity, name: "") }.to raise_error(Mongoid::Errors::Validations)
        #end
      #end

      #context "when property uri is not valid" do
        #it "raises an error" do
          #expect { 
            #FactoryGirl.create(:setting_intensity, name: "Status", properties: [ {uri: "not_valid"} ])
          #}.to raise_error(Mongoid::Errors::Validations)
        #end
      #end

      #it "does not create a new resource" do
        #count = Status.count
        #expect { FactoryGirl.create(:setting_intensity, name: "") }.to raise_error(Mongoid::Errors::Validations)
        #Status.count.should == count
      #end
    #end

    #context "with no properties" do

      #let(:status) { FactoryGirl.create(:setting_intensity) }
      #subject      { status.properties }

      #it "should not change anything" do
        #subject.should have(2).items
      #end
    #end

    #context "with empty properties" do

      #let(:status) { FactoryGirl.create(:setting_intensity, properties: []) }
      #subject      { status.properties }

      #it "removes all properties" do
        #subject.should have(0).items
      #end
    #end

    #context "with not valid JSON" do

      #it "should raise an error" do
        #expect { 
          #FactoryGirl.create(:setting_intensity, properties: "string") 
        #}.to raise_error
      #end
    #end
  #end
#end
