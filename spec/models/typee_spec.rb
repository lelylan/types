require 'spec_helper'

describe Typee do

  it { should_not allow_mass_assignment_of(:created_from) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  it { ['true', 'false'].each { |value| should allow_value(value).for(:public) } }
  it { should_not allow_value('not_valid').for(:public) }

  its(:public) { should == 'true' }


  context "#find_properties_id" do

    context "with valid URIs" do

      let(:property_uris) { [Settings.properties.status.uri, Settings.properties.intensity.uri] }
      let(:property_ids)  { [Settings.properties.status.property_id, Settings.properties.intensity.property_id] }

      subject { FactoryGirl.create(:type_no_connections, properties: property_uris) }

      it "sets the properties relation with property ids" do
        subject.properties.should == property_ids
      end

    end

    context "with not valid URIs" do

      let(:property_ids) { ["not_valid"] }

      it "raises a not valid error" do
        expect {
          FactoryGirl.create(:type_no_connections, properties: property_ids)) 
        }.to raise_error(Mongoid::Errors::Validations) 
      end

      it "does not create the resource" do
        expect {
          FactoryGirl.create(:type_no_connections, properties: property_ids)) 
        }.to not_change
      end
    end

    context "with empty list" do

      let(:property_ids) { [] }

      subject { FactoryGirl.create(:type, properties: property_ids )}

      it "removes all properties" do
        subject.properties.should have(0).items
      end
    end
  end
end
