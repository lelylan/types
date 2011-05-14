require 'spec_helper'

describe Function do

  it { should validate_presence_of(:name) }

  it { should allow_value(VALID_URIS).for(:uri) }
  it { should_not allow_value(INVALID_URIS).for(:uri) }

  it { should allow_value(VALID_URIS).for(:created_from) }
  it { should_not allow_value(INVALID_URIS).for(:created_from) }

end
