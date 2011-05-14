require 'spec_helper'

describe FunctionProperty do

  it { should validate_presence_of(:uri) }
  it { should allow_value(VALID_URIS).for(:uri) }
  it { should_not allow_value(INVALID_URIS).for(:uri) }

  it { should allow_value("true").for(:secret) }
  it { should allow_value("false").for(:secret) }
  it { should_not allow_value("example").for(:secret) }

  it { should allow_value("true").for(:before) }
  it { should allow_value("false").for(:before) }
  it { should_not allow_value("example").for(:before) }

end
