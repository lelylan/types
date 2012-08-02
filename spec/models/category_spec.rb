require 'spec_helper'

describe Category do

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  it { should_not allow_mass_assignment_of :resource_owner_id }
end
