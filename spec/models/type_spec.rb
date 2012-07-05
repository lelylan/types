require 'spec_helper'

describe Type do

  it { should_not allow_mass_assignment_of(:created_from) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  it { ['true', 'false'].each { |value| should allow_value(value).for(:public) } }
  it { should_not allow_value('not_valid').for(:public) }

  its(:public) { should == 'true' }


  context "#find_properties_id" do

    context "with valid URIs" do

      let(:property_uris) { [Settings.properties.status.uri, Settings.properties.intensity.uri] }
      let(:properties_id)  { [Settings.properties.status.property_id, Settings.properties.intensity.property_id] }

      subject { FactoryGirl.create(:type_no_connections, properties: property_uris) }

      it "sets the properties relation with property ids" do
        subject.properties.should == properties_id
      end

    end

    context "with not valid URIs" do

      let(:properties_id) { [nil] }

      it "raises a not valid error" do
        expect {
          FactoryGirl.create(:type_no_connections, properties: properties_id)
        }.to raise_error(Lelylan::Errors::ValidURI) 
      end

      context "when raise an error" do

        let(:count) { Type.count }
        before { expect { FactoryGirl.create(:type_no_connections, properties: properties_id) }.to raise_error }

        it "should not add a new record" do
          count.should == Type.count
        end
      end
    end

    context "with empty list" do

      let(:properties_id) { [] }

      subject { FactoryGirl.create(:type, properties: properties_id ) }

      it "removes all properties" do
        subject.properties.should have(0).items
      end
    end
  end
end
