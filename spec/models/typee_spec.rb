require 'spec_helper'

describe Typee do

  it { should_not allow_mass_assignment_of(:created_from) }
  it { should_not allow_mass_assignment_of(:properties) }
  it { should_not allow_mass_assignment_of(:functions) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  it { ['true', 'false'].each { |value| should allow_value(value).for(:public) } }
  it { should_not allow_value('not_valid').for(:public) }
  
  its(:public) { should == 'true' } 
end
