require 'spec_helper'

describe Property do
  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:uri) }
  it { should allow_value(Settings.validation.valid_uri).for(:uri) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:uri) }

  it { should validate_presence_of(:created_from) }
  it { should allow_value(Settings.validation.valid_uri).for(:created_from) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:created_from) }

  describe "values" do
    before  { @values = [1, {key: 'value'}, ['1']] }
    subject { Factory(:intensity, values: @values).values }

    it { should have(3).itmes }
    it { subject[0].should == "1" }
    it { subject[1].should == {key: 'value'}.to_s }
    it { subject[2].should == ['1'].to_s }
  end
end
