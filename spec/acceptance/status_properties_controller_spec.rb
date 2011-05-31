require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusPropertiesController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Property.destroy_all }
  before { Status.destroy_all }

  before { @resource = Factory(:is_setting_intensity) }
  before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
  before { @connection = Factory(:intensity) }
  before { @not_owned_connection = Factory(:not_owned_intensity) }


  # GET /statuses/{status-id}/properties?uri={property-uri}
  context ".show" do
    before { @uri = "#{host}/statuses/#{@resource.id}/properties?uri=#{@connection.uri}" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view all resources" do
        visit @uri
        page.status_code.should == 200
        status_property = @resource.status_properties.where(uri: @connection.uri).first
        should_have_status_property_detailed(status_property, @resource, @connection)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "statuses", "/properties"
      it_should_behave_like "a rescued 404 connection", "visit @uri", "statuses", "/properties"
    end
  end



  # POST /statuses
  context ".create" do
    before { @resource = Factory(:default_status) }
    before { @uri = "#{host}/statuses/#{@resource.id}/properties" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ 
        uri: Settings.properties.intensity.uri,
        values: Settings.statuses.has_set_intensity.values,
        pending: 'true'
      }}

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        page.status_code.should == 201
        @resource.reload.status_properties.should have(1).item
        status_property = @resource.status_properties.first
        should_have_status_property_detailed(status_property, @resource, @connection)
        should_have_valid_json(page.body)
      end

      context "with pending nil" do
        before { params[:pending] = nil }
        scenario "should render null" do
          page.driver.post(@uri, params.to_json)
          page.status_code.should == 201
          page.should have_content 'null'
          should_have_valid_json(page.body)
        end
      end

      context "with existing connection" do
        before { @resource = Factory(:is_setting_intensity) }
        before { @uri = "#{host}/statuses/#{@resource.id}/properties" }
        scenario "get an 'existing' notification" do
          page.driver.post(@uri, params.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
          page.should have_content 'connection.found'
        end
      end

      context "with not owned connection" do
        scenario "get a not found notification" do
          params[:uri] = @not_owned_connection.uri
          page.driver.post(@uri, params.to_json)
          should_have_a_not_found_connection(params[:uri])
          should_have_valid_json(page.body)
        end
      end

      context "with not valid params (no URI)" do
        scenario "get a not valid notification" do
          page.driver.post(@uri, {}.to_json)
          should_have_a_not_found_connection(@uri)
          should_have_valid_json(page.body)
        end
      end

      context "#values" do
        it_should_behave_like "an array field", "values", "page.driver.post(@uri, params.to_json)"
      end

      it_should_behave_like "a default resource", "page.driver.post(@uri)", "/properties"
      it_should_behave_like "a rescued 404 resource", "page.driver.post(@uri)", "statuses", "/properties"
    end
  end


  # PUT /statuses/{status-id}/properties?uri={property-uri}
  context ".update" do
    before { @uri = "#{host}/statuses/#{@resource.id}/properties?uri=#{@connection.uri}" }

    it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ values: ['100.0', '200.0'], pending: false}}

      scenario "update resource" do
        page.driver.put(@uri, params.to_json)
        page.status_code.should == 200
        page.should have_content '200.0'
        page.should have_content 'false'
        should_have_valid_json(page.body)
      end

      context "with new URI connection" do
        before { params[:uri] = Settings.properties.status.uri }
        scenario "should not change URI" do
          page.driver.put(@uri, params.to_json)
          page.should_not have_content Settings.properties.status.uri
          should_have_valid_json(page.body)
        end
      end

      context "with not valid params" do
        scenario "get a not valid notification" do
          # All values are optionals
        end
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "statuses", "/properties"
    end
  end


  # DELETE /statuses/{status-id}/properties?uri={property-uri}
  context ".destroy" do
    before { @uri = "#{host}/statuses/#{@resource.id}/properties?uri=#{@connection.uri}" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view all resources" do
        status_property = @resource.status_properties.where(uri: @connection.uri).first
        @resource.status_properties.should have(1).item
        page.driver.delete(@uri)
        @resource.reload.status_properties.should have(0).item
        page.status_code.should == 200
        should_have_status_property_detailed(status_property, @resource, @connection)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a default resource", "page.driver.delete(@uri)", "/properties"
      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "statuses", "/properties"
      it_should_behave_like "a rescued 404 connection", "page.driver.delete(@uri)", "statuses", "/properties"
    end
  end
end

