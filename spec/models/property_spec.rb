require 'spec_helper'

describe Property do
  # presence
  it { should validate_presence_of(:created_from) }
  it { should validate_presence_of(:name) }

  # mass assignment
  it { should_not allow_mass_assignment_of(:created_from) }

  # default values
  its(:default) { should == '' }
  its(:values)  { should == [] }

  # values related methods
  describe "#values" do

    context "receives objects instead of strings" do
      let(:objects)  { [ 1, {key: 'value'}, ['1'] ] }
      let(:strings)  { objects.map {|object| object.to_s} }
      let(:intensity) { FactoryGirl.create(:intensity, values: objects) } 

      it "normalizes the objects into strings" do
        intensity.values.should == strings
      end
    end
  end
end
