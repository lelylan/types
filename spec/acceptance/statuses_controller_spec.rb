require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Status.destroy_all }


  # GET /statuses
  context ".index" do
    before { @uri = "/statuses?page=1&per=100" }
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
        should_have_valid_json(page.body)
      end

      it_should_behave_like "rescued when resource not found", 
                            "visit @uri", "statuses"
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

      it_should_behave_like "rescued when resource not found",
                            "page.driver.put(@uri)", "statuses"
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

      it_should_behave_like "rescued when resource not found",
                            "page.driver.delete(@uri)", "statuses"
    end
  end
end
