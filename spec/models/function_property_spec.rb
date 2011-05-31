require 'spec_helper'

describe FunctionProperty do
  it { should validate_presence_of(:uri) }
  it { should allow_value(Settings.validation.valid_uri).for(:uri) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:uri) }

  it { should allow_value(true).for(:secret) }
  it { should allow_value(false).for(:secret) }
  it { should_not allow_value('not_valid').for(:secret) }

  it { should allow_value('').for(:filter) }
  it { should allow_value('before').for(:filter) }
  it { should_not allow_value('not_valid').for(:filter) }
end
