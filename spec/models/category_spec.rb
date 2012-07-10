require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:created_from) }
  it { Settings.validation.uris.valid.each {|uri| should allow_value(uri).for(:created_from)} }
  it { Settings.validation.uris.not_valid.each {|uri| should_not allow_value(uri).for(:created_from)} }

  it { should_not allow_mass_assignment_of(:created_from) }
end
