require 'spec_helper'

describe Property do

  it { should_not allow_mass_assignment_of :resource_owner_id }

  it { should validate_presence_of :resource_owner_id }
  it { should validate_presence_of :name }
end
