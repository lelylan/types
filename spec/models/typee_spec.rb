require 'spec_helper'

describe Typee do
  # presence
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  # mass assignment
  it { should_not allow_mass_assignment_of(:created_from) }

  # including
  it { should allow_value(true).for(:public) }
  it { should allow_value(false).for(:public) }
  it { should_not allow_value('not_boolean').for(:public) }
  
  # default values
  its(:public) { should == true } 
end
