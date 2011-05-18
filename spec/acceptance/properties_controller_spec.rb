require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "PropertyController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Property.destroy_all }


  # GET /properties
  context ".index" do
    before { @uri = "/properties?page=1&per=100" }
    before { @resource = Factory(:intensity) }
    before { @not_owned_resource = Factory(:not_owned_intensity) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        should_have_property(@resource)
        should_not_have_property(@not_owned_resource)
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end
  end


  # GET /properties/{property-id}
  context ".show" do
    before { @resource = Factory(:intensity) }
    before { @uri = "/properties/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_intensity) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_property(@resource)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "properties"
    end
  end


  # POST /properties
  context ".create" do
    before { @uri =  "/properties" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ 
        name: Settings.properties.intensity.name,
        default: '0.0',
        values: Settings.properties.intensity.values
      }}

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        @resource = Property.last
        page.status_code.should == 201
        should_have_property(@resource)
        should_have_valid_json(page.body)
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
    end
  end


  # PUT /properties/{property-id}
  context ".update" do
    before { @resource = Factory(:intensity) }
    before { @uri =  "/properties/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_intensity) }

    it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: "Set intensity updated" }}

      scenario "create resource" do
        page.driver.put(@uri, params.to_json)
        page.status_code.should == 200
        should_have_property(@resource.reload)
        page.should have_content "updated"
        should_have_valid_json(page.body)
      end

      scenario "not valid params" do
        page.driver.put(@uri, {name: ''}.to_json)
        should_have_a_not_valid_resource
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "properties"

      context "#values" do
        it_should_behave_like "an array field", "values", "page.driver.put(@uri, params.to_json)"
      end
    end
  end


  # DELETE /properties/{property-id}
  context ".destroy" do
    before { @resource = Factory(:intensity) }
    before { @uri =  "/properties/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_intensity) }

    it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "delete resource" do
        lambda {
          page.driver.delete(@uri, {}.to_json)
        }.should change{ Property.count }.by(-1)
        page.status_code.should == 200
        should_have_property(@resource)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "properties"
    end
  end

end

