require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Property.destroy_all }
  before { Status.destroy_all }

  before { @resource = Factory(:is_setting_intensity) }
  before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
  before { @connection = Factory(:property_intensity) }
  before { @not_owned_connection = Factory(:not_owned_property_intensity) }


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
        should_have_status_property_detailed(status_property, @connection)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "rescued when resource not found", 
                            "visit @uri", "statuses", "/properties"
 
      it_should_behave_like "rescued when connection not found", 
                            "visit @uri", "statuses", "/properties"
    end
  end


  # POST /statuses
  context ".create" do
    before { @resource = Factory(:status) }
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
        should_have_status_property_detailed(status_property, @connection)
        should_have_valid_json(page.body)
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

      context "#values" do
        it_should_behave_like "an array field", "values", "page.driver.post(@uri, params.to_json)"
      end

      it_should_behave_like "rescued when resource not found", 
                            "visit @uri", "statuses", "/properties"
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
        page.driver.delete(@uri, {}.to_json)
        @resource.reload.status_properties.should have(0).item
        page.status_code.should == 200
        should_have_status_property_detailed(status_property, @connection)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "rescued when resource not found", 
                            "visit @uri", "statuses", "/properties"
 
      it_should_behave_like "rescued when connection not found", 
                            "visit @uri", "statuses", "/properties"
    end
  end
end

