require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "FunctionController" do
  before { Property.destroy_all }
  before { Function.destroy_all }
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { @resource = Factory(:function_complete) }
  before { @not_owned_resource = Factory(:not_owned_function) }
  before { @connection = Factory(:property_intensity) }
  before { @not_owned_connection = Factory(:not_owned_property_intensity) }


  # GET /functions/{function-id}/properties?uri={property-uri}
  context ".show" do
    before { @uri = "#{host}/functions/#{@resource.id}/properties?uri=#{@connection.uri}" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view all resources" do
        visit @uri
        page.status_code.should == 200
        function_property = @resource.function_properties.where(uri: @connection.uri).first
        should_have_function_property_detailed(function_property, @connection)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "functions", "/properties"
      it_should_behave_like "a rescued 404 connection", "visit @uri", "functions", "/properties"
    end
  end


  # POST /functions
  context ".create" do
    before { @resource = Factory(:function) }
    before { @uri = "#{host}/functions/#{@resource.id}/properties" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ 
        uri: Settings.properties.intensity.uri,
        value: Settings.properties.intensity.default_value,
        secret: true,
        before: false
      }}

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        page.status_code.should == 201
        @resource.reload.function_properties.should have(1).item
        function_property = @resource.function_properties.first
        should_have_function_property_detailed(function_property, @connection)
        should_have_valid_json(page.body)
      end

      context "with existing connection" do
        before { @resource = Factory(:function_complete) }
        before { @uri = "#{host}/functions/#{@resource.id}/properties" }
        scenario "get an 'existing' notification" do
          page.driver.post(@uri, params.to_json)
          page.should have_content 'connection.found'
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end

      context "with not owned connection" do
        scenario "get a not found notification" do
          params[:uri] = @not_owned_connection.uri
          page.driver.post(@uri, params.to_json)
          should_have_a_not_found_connection(@uri)
          should_have_valid_json(page.body)
        end
      end

      context "with not valid params" do
        scenario "get a not valid notification" do
          page.driver.post(@uri, {}.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.post(@uri)", "functions", "/properties"
    end
  end


  # DELETE /functions/{function-id}/properties?uri={property-uri}
  context ".destroy" do
    before { @uri = "#{host}/functions/#{@resource.id}/properties?uri=#{@connection.uri}" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view all resources" do
        function_property = @resource.function_properties.where(uri: @connection.uri).first
        @resource.function_properties.should have(2).item
        page.driver.delete(@uri, {}.to_json)
        @resource.reload.function_properties.should have(1).item
        page.status_code.should == 200
        should_have_function_property_detailed(function_property, @connection)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "functions", "/properties"
      it_should_behave_like "a rescued 404 connection", "page.driver.delete(@uri)", "functions", "/properties"
    end
  end
end
