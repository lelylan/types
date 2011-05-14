require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "FunctionController" do
  before { Property.destroy_all }
  before { Function.destroy_all }
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { @resource = Factory(:function_complete) }
  before { @not_owned_resource = Factory(:not_owned_function) }


  # GET /functions/{function-id}/properties?uri={property-uri}
  context ".show" do
    before { @connection = Factory(:property_intensity) }
    before { @not_owned_connection = Factory(:not_owned_property_intensity) }
    before { @uri = "#{host}/functions/#{@resource.id}/properties?uri=#{@connection.uri}" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        function_property = @resource.function_properties.where(uri: @connection.uri).first
        should_have_function_property_detailed(function_property, @connection)
        should_have_valid_json(page.body)
      end
    end

    it_should_behave_like "rescued when resource not found", 
                          "visit @uri", "functions", "/properties"
 
    it_should_behave_like "rescued when connection not found", 
                          "visit @uri", "functions", "/properties"
  end


  ## POST /functions
  #context ".create" do
    #before { @uri =  "/functions" }

    #it_should_behave_like "protected resource", "page.driver.post(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #let(:params) {{ name: Settings.functions.set_intensity.name }}

      #scenario "create resource" do
        #page.driver.post(@uri, params.to_json)
        #@resource = Function.last
        #page.status_code.should == 201
        #should_have_function(@resource)
        #should_have_valid_json(page.body)
      #end

      #scenario "not valid params" do
        #page.driver.post(@uri, {}.to_json)
        #should_have_a_not_valid_resource
        #should_have_valid_json(page.body)
      #end
    #end
  #end


  ## PUT /functions/{function-id}
  #context ".update" do
    #before { @resource = Factory(:function_complete) }
    #before { @uri =  "/functions/#{@resource.id.as_json}" }
    #before { @not_owned_resource = Factory(:not_owned_function) }

    #it_should_behave_like "protected resource", "page.driver.put(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #let(:params) {{ name: "Set intensity updated" }}

      #scenario "create resource" do
        #page.driver.put(@uri, params.to_json)
        #page.status_code.should == 200
        #should_have_function(@resource.reload)
        #should_have_function_property(@resource.function_properties[0])
        #should_have_function_property(@resource.function_properties[1])
        #page.should have_content "updated"
        #should_have_valid_json(page.body)
      #end

      #scenario "not valid params" do
        #page.driver.put(@uri, {name: ''}.to_json)
        #should_have_a_not_valid_resource
      #end

      #it_should_behave_like "rescued when not found",
        #"page.driver.put(@uri)", "functions"
    #end
  #end


  ## DELETE /functions/{function-id}
  #context ".destroy" do
    #before { @resource = Factory(:function_complete) }
    #before { @uri =  "/functions/#{@resource.id.as_json}" }
    #before { @not_owned_resource = Factory(:not_owned_function) }

    #it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #scenario "delete resource" do
        #lambda {
          #page.driver.delete(@uri, {}.to_json)
        #}.should change{ Function.count }.by(-1)
        #page.status_code.should == 200
        #should_have_function(@resource)
        #should_have_function_property(@resource.function_properties[0])
        #should_have_function_property(@resource.function_properties[1])
        #should_have_valid_json(page.body)
      #end

      #it_should_behave_like "rescued when not found",
        #"page.driver.delete(@uri)", "functions"
    #end
  #end

end
