shared_examples_for "not valid json input" do |action, options|

  it "gets a not valid notification" do
    params = "I'm not an Hash"
    eval(action)
    page.status_code.should == 422
    has_a_not_valid_resource code: "notifications.json.not_valid", error: "Not valid", method: options[:method]
    page.should have_content params
  end
end

shared_examples_for "check valid params" do |action, options|

  it "does not create a resource" do
    eval(action)
    page.status_code.should == 422
    has_a_not_valid_resource options
  end
end
