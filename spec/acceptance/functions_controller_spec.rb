require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "FunctionController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Function.destroy_all }


  # GET /functions
  context ".index" do
    before { @uri = "/functions" }
    before { @resource = Factory(:function) }
    before { @not_owned_resource = Factory(:not_owned_function) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        should_have_function(@resource)
        should_not_have_function(@not_owned_resource)
        should_have_pagination(@uri)
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end
  end


  # GET /functions/{function-id}
  context ".show" do
    before { @resource = Factory(:function_complete) }
    before { @uri = "/functions/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_function) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_function(@resource)
        should_have_function_property(@resource.function_properties[0])
        should_have_function_property(@resource.function_properties[1])
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "functions"
    end
  end


  # POST /functions
  context ".create" do
    before { @uri =  "/functions" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: Settings.functions.set_intensity.name }}

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        @resource = Function.last
        page.status_code.should == 201
        should_have_function(@resource)
        should_have_valid_json(page.body)
      end

      
      scenario "not valid params" do
        page.driver.post(@uri, {}.to_json)
        should_have_a_not_valid_resource
        should_have_valid_json(page.body)
      end
    end
  end

  # POST /functions
  # { properties: [...] }
  context ".create with properties" do
    before { @uri =  "/functions" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before do 
        @properties = [
          { uri: Settings.properties.status.uri, value: 'on'},
          { uri: Settings.properties.intensity.uri, value: '10.0'} ]
      end
      let(:params) {{ name: Settings.functions.set_intensity.name, properties: @properties }}

      scenario "create function properties" do
        page.driver.post(@uri, params.to_json)
        @resource = Function.last
        should_have_function_property(@resource.function_properties[0])
        should_have_function_property(@resource.function_properties[1])
      end

      context "with duplicated property URI" do
        before do 
          @properties = [
            { uri: Settings.properties.status.uri, value: 'on'},
            { uri: Settings.properties.status.uri, value: 'off'} ]
          params[:properties] = @properties
        end

        scenario "create function properties" do
          page.driver.post(@uri, params.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end

      context "with one not valid property" do
        before do 
          @properties = [
            { uri: Settings.properties.status.uri, value: 'on'},
            { uri: Settings.properties.intensity.uri, value: 'off', filter: 'not valid'} ]
          params[:properties] = @properties
        end

        scenario "create function properties" do
          page.driver.post(@uri, params.to_json)
          Function.count.should == 0
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end
    end
  end


  # PUT /functions/{function-id}
  context ".update" do
    before { @resource = Factory(:function_complete) }
    before { @uri =  "/functions/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_function) }

    it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: "Set intensity updated" }}

      scenario "update resource" do
        page.driver.put(@uri, params.to_json)
        page.status_code.should == 200
        should_have_function(@resource.reload)
        should_have_function_property(@resource.function_properties[0])
        should_have_function_property(@resource.function_properties[1])
        page.should have_content "updated"
        should_have_valid_json(page.body)
      end

      context "when update properties" do
        scenario "with nil as value" do
          page.driver.put(@uri, params.to_json)
          should_have_function_property(@resource.function_properties[0])
          should_have_function_property(@resource.function_properties[1])
          should_have_valid_json(page.body)
        end

        scenario "with [] values" do
          params[:properties] = []
          page.driver.put(@uri, params.to_json)
          page.should_not have_content Settings.properties.status.uri
          page.should_not have_content Settings.properties.intensity.uri
          should_have_valid_json(page.body)
        end

        scenario "with one property" do
          params[:properties] = [{uri: Settings.properties.status.uri}]
          page.driver.put(@uri, params.to_json)
          page.should have_content Settings.properties.status.uri
          page.should_not have_content Settings.properties.intensity.uri
          should_have_valid_json(page.body)
        end
      end

      scenario "not valid params" do
        page.driver.put(@uri, {name: ''}.to_json)
        should_have_a_not_valid_resource
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "functions"
    end
  end


  # DELETE /functions/{function-id}
  context ".destroy" do
    before { @resource = Factory(:function_complete) }
    before { @uri =  "/functions/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_function) }

    it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "delete resource" do
        lambda {
          page.driver.delete(@uri, {}.to_json)
        }.should change{ Function.count }.by(-1)
        page.status_code.should == 200
        should_have_function(@resource)
        should_have_function_property(@resource.function_properties[0])
        should_have_function_property(@resource.function_properties[1])
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "functions"
    end
  end

end
