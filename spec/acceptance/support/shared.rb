# Not authorized requests
shared_examples_for "protected resource" do |action|
  context "when not logged in" do
    before { basic_auth_cleanup }
    scenario "is not authorized" do
      eval(action)
      should_not_be_authorized
    end
  end
end

# Not found resources
shared_examples_for "rescued when resource not found" do |action, controller, connection = ""|
  context "with not existing resource" do
    scenario "get a not found notification" do
      @resource.destroy
      eval(action)
      should_have_a_not_found_resource(@uri)
      should_have_valid_json(page.body)
    end
  end

  context "with not owned resource" do
    scenario "get a not found notification" do
      @uri = "/#{controller}/#{@not_owned_resource.id.as_json}#{connection}"
      eval(action)
      should_have_a_not_found_resource(@uri)
      should_have_valid_json(page.body)
    end
  end

  context "with illegal id" do
    scenario "get a not found notification" do
      @uri = "/#{controller}/0#{connection}"
      eval(action)
      should_have_a_not_found_resource(@uri)
      should_have_valid_json(page.body)
    end
  end
end

shared_examples_for "rescued when connection not found" do |action, controller, connection|
  context "with not existing resource" do
    scenario "get a not found notification" do
      @connection.destroy
      eval(action)
      should_have_a_not_found_connection(@uri)
      should_have_valid_json(page.body)
    end
  end

  context "with not owned resource" do
    scenario "get a not found notification" do
      @uri = "/#{controller}/#{@resource.id.as_json}#{connection}?uri=#{@not_owned_connection.uri}"
      eval(action)
      should_have_a_not_found_connection(@uri)
      should_have_valid_json(page.body)
    end
  end
end

shared_examples_for "an array field" do |field, action|
  context "with not valid ##{field}" do
    context "when Hash" do
      before { params[field] = {} }
      scenario "get a not valid notification" do
        eval(action)
        should_have_a_not_valid_resource
        should_have_valid_json(page.body) 
        page.should have_content "but received a Hash"
      end
    end
    
    context "when String" do
      before { params[field] = "not_valid" }
      scenario "get a not valid notification" do
        eval(action)
        should_have_a_not_valid_resource
        should_have_valid_json(page.body)
        page.should have_content "but received a String"
      end
    end
  end
end

