require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Status.destroy_all }


  # GET /statuses
  context ".index" do
    before { @uri = "/statuses" }
    before { @resource = Factory(:is_setting_intensity) }
    before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        should_have_status(@resource)
        should_have_status_property(@resource.status_properties[0])
        should_not_have_status(@not_owned_resource)
        should_have_pagination(@uri)
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end
  end


  # GET /statuses/{status-id}
  context ".show" do
    before { @resource = Factory(:is_setting_intensity) }
    before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
    before { @uri = "/statuses/#{@resource.id.as_json}" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_status(@resource)
        should_have_status_property(@resource.status_properties[0])
        page.should_not have_content 'range'
        should_have_valid_json(page.body)
      end

      describe "range" do
        context "when defined" do
          before  { @resource.status_properties.first.update_attributes(range_start: 1000, range_end: 100000) }
          subject { @resource.status_properties.first }
          scenario "should be visible" do
            visit @uri
            should_have_status_property_range(subject)
          end
        end
        context "when defined" do
          before  { @resource.status_properties.first.update_attributes(range_start: 1000) }
          subject { @resource.status_properties.first }
          scenario "should be visible" do
            visit @uri
            page.should_not have_content "1000"
          end
        end
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "statuses"
    end
  end


  # POST /statuses
  context ".create" do
    before { @uri =  "/statuses" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: Settings.statuses.is_setting_intensity.name }}

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        @resource = Status.last
        page.status_code.should == 201
        should_have_status(@resource)
        should_have_valid_json(page.body)
      end

      scenario "not valid params" do
        page.driver.post(@uri, {}.to_json)
        should_have_a_not_valid_resource
        should_have_valid_json(page.body)
      end
    end
  end


  # POST /statuses
  # { properties: [...] }
  context ".create with properties" do
    before { @uri =  "/statuses" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before do 
        @properties = [
          {uri: Settings.properties.status.uri, values: %w(on)},
          {uri: Settings.properties.intensity.uri, value: %w(10.0)} ]
      end
      let(:params) {{ name: Settings.statuses.is_setting_max.name, properties: @properties }}

      scenario "create status properties" do
        page.driver.post(@uri, params.to_json)
        @resource = Status.last
        should_have_status_property(@resource.status_properties[0])
        should_have_status_property(@resource.status_properties[1])
      end

      context "with duplicated property URI" do
        before do 
          @properties = [
            { uri: Settings.properties.status.uri, values: %w(on)},
            { uri: Settings.properties.status.uri, values: %w(off)} ]
          params[:properties] = @properties
        end

        scenario "create status properties" do
          page.driver.post(@uri, params.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end

      context "with one not valid property" do
        # all params, except URI, which is handled differently, are optionals.
      end
    end
  end


  # PUT /statuses/{status-id}
  context ".update" do
    before { @resource = Factory(:is_setting_intensity) }
    before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
    before { @uri =  "/statuses/#{@resource.id.as_json}" }

    it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: "Setting intensity updated" }}

      scenario "create resource" do
        page.driver.put(@uri, params.to_json)
        page.status_code.should == 200
        should_have_status(@resource.reload)
        should_have_status_property(@resource.status_properties[0])
        page.should have_content "updated"
        should_have_valid_json(page.body)
      end

      scenario "not valid params" do
        page.driver.put(@uri, {name: ''}.to_json)
        should_have_a_not_valid_resource
      end

      context "when default status" do
        it_should_behave_like "a default resource", "page.driver.put(@uri)"
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "statuses"
    end
  end


  # PUT /statuses/{status-id}
  # { properties: [...] }
  context ".update with properties" do
    before { @resource = Factory(:is_setting_intensity) }
    before { @uri =  "/statuses/#{@resource.id.as_json}" }

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: "Setting intensity updated" }}

      context "when update properties" do
        scenario "with nil as value" do
          page.driver.put(@uri, params.to_json)
          should_have_status_property(@resource.status_properties[0])
          should_have_valid_json(page.body)
        end

        scenario "with [] values" do
          params[:properties] = []
          page.driver.put(@uri, params.to_json)
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
    end
  end


  # DELETE /statuses/{status-id}
  context ".destroy" do
    before { @resource = Factory(:is_setting_intensity) }
    before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
    before { @uri =  "/statuses/#{@resource.id.as_json}" }

    it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "delete resource" do
        lambda {
          page.driver.delete(@uri)
        }.should change{ Status.count }.by(-1)
        page.status_code.should == 200
        should_have_status(@resource)
        should_have_status_property(@resource.status_properties[0])
        should_have_valid_json(page.body)
      end

      context "when default status" do
        it_should_behave_like "a default resource", "page.driver.delete(@uri)"
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "statuses"
    end
  end
end
