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

  describe "#values" do
    context "when they are not string" do
      before { @intensity = FactoryGirl.create(:intensity, values: [1, {key: 'value'}, ['1']]) }

      it "accept any object without transforming it in a string" do
        @intensity.values.should have(3).objects
      end
    end
  end
end
