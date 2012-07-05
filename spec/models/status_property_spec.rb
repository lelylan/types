require 'spec_helper'

describe StatusProperty do
  it { should validate_presence_of(:uri) }

  it { should validate_presence_of(:uri) }
  it { should allow_value(Settings.validation.valid_uri).for(:uri) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:uri) }

  it { should allow_value(true).for(:pending) }
  it { should allow_value(false).for(:pending) }
  it { should allow_value('example').for(:pending) } # set it to nil

  describe "values" do
    before  { @values = [1, {key: 'value'}, ['1']] }
    before  { @resource = Factory(:is_setting_intensity) }
    before  { @resource.status_properties.first.update_attributes(values: @values) }
    subject { @resource.status_properties.first.values }

    it { should have(3).itmes }
    it { subject[0].should == "1" }
    it { subject[1].should == {key: 'value'}.to_s }
    it { subject[2].should == ['1'].to_s }
  end
end
