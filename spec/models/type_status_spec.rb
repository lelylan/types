require 'spec_helper'

describe TypeStatus do
  it { should validate_presence_of(:uri) }
  it { should allow_value(VALID_URIS).for(:uri) }
  it { should_not allow_value(INVALID_URIS).for(:uri) }
end
