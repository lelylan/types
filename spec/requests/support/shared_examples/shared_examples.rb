shared_examples_for "boolean" do |field, resource|
  it "transforms strings to corresponding true value" do
    resource[field] = "true"
    resource[field].should == true
  end

  it "transforms strings to corresponding true value" do
    resource[field] = "false"
    resource[field].should == false
  end

  it "sets false any string different from a boolean string value" do
    resource[field] = "string"
    resource[field].should == false
  end
end
