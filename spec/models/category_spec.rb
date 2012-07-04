require 'spec_helper'

describe Category do
  # presence
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:created_from) }

  # mass assignment
  it { should_not allow_mass_assignment_of(:created_from) }
end
