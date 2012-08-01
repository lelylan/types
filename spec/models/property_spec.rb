require 'spec_helper'

describe Property do

  it { should_not allow_mass_assignment_of :resource_owner_id }

  it { should validate_presence_of :resource_owner_id }
  it { should validate_presence_of :name }

  its(:default) { should == '' }
  its(:values)  { should == [] }

  describe "#values" do

    context "receives objects instead of strings" do

      let(:objects)   { [ 1, { key: 'value' }, ['1'] ] }
      let(:strings)   { objects.map { |obj| obj.to_s } }
      let(:intensity) { FactoryGirl.create :intensity, values: objects } 

      it "normalizes the objects into strings" do
        intensity.values.should == strings
      end
    end
  end
end
