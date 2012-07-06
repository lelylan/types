require 'spec_helper'
#require Rails.root + 'app/models/type'
#load Rails.root + 'app/models/type.rb'
#require_dependency "app/models/type"


describe Type do

  it { should_not allow_mass_assignment_of(:created_from) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  it { ['true', 'false'].each { |value| should allow_value(value).for(:public) } }
  it { should_not allow_value('not_valid').for(:public) }

  its(:public) { should == 'true' }


  context "#find_properties" do

    context "with valid URIs" do

      let(:property_uris) { [Settings.properties.status.uri, Settings.properties.intensity.uri] }
      let(:property_ids)  { [Settings.properties.status.property_id, Settings.properties.intensity.property_id] }

      subject { FactoryGirl.create(:type_no_connections, properties: property_uris) }

      it "sets the properties relation with property ids" do
        subject.property_ids.should == property_ids
      end

    end

    context "with not valid URIs" do

      let(:property_ids) { [nil] }

      it "raises a not valid error" do
        expect {
          FactoryGirl.create(:type_no_connections, properties: property_ids)
        }.to raise_error(Lelylan::Errors::ValidURI) 
      end

      context "when raise an error" do

        let(:count) { Type.count }
        before { expect { FactoryGirl.create(:type_no_connections, properties: property_ids) }.to raise_error }

        it "does not add a new record" do
          count.should == Type.count
        end
      end
    end

    context "with empty list" do

      let(:property_ids) { [] }

      subject { FactoryGirl.create(:type, properties: property_ids ) }

      it "removes all properties" do
        subject.properties.should have(0).items
      end
    end
  end

  context "#find_functions" do

    context "with valid URIs" do

      let(:function_uris) { [Settings.functions.set_intensity.uri, Settings.functions.turn_on.uri, Settings.functions.turn_off.uri] }
      let(:function_ids)  { [Settings.functions.set_intensity.function_id, Settings.functions.turn_on.function_id, Settings.functions.turn_off.function_id] }

      subject { FactoryGirl.create(:type_no_connections, functions: function_uris) }

      it "sets the functions relation with function ids" do
        subject.function_ids.should == function_ids
      end

    end

    context "with not valid URIs" do

      let(:function_ids) { [nil] }

      it "raises a not valid error" do
        expect {
          FactoryGirl.create(:type_no_connections, functions: function_ids)
        }.to raise_error(Lelylan::Errors::ValidURI) 
      end

      context "when raises an error" do

        let(:count) { Type.count }
        before { expect { FactoryGirl.create(:type_no_connections, functions: function_ids) }.to raise_error }

        it "does not add a new record" do
          count.should == Type.count
        end
      end
    end

    context "with empty list" do

      let(:functions_id) { [] }

      subject { FactoryGirl.create(:type, functions: functions_id ) }

      it "removes all properties" do
        subject.functions.should have(0).items
      end
    end
  end

end
