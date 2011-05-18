require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "TypeController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Type.destroy_all }
  before { Property.destroy_all }
  before { Function.destroy_all }
  before { Status.destroy_all }
  before { Category.destroy_all }

  before { @status = Factory(:status) }
  before { @intensity = Factory(:intensity) }
  before { @set_intensity = Factory(:set_intensity) }
  before { @turn_on = Factory(:turn_on) }
  before { @turn_off = Factory(:turn_off) }
  before { @is_setting_intensity = Factory(:is_setting_intensity) }
  before { @is_setting_max = Factory(:is_setting_max) }
  before { @has_set_intensity = Factory(:has_set_intensity) }
  before { @has_set_max = Factory(:has_set_max) }
  before { @category = Factory(:category) }


  # GET /types
  context ".index" do
    before { @uri = "/types?page=1&per=100" }
    before { @resource = Factory(:type) }
    before { @not_owned_resource = Factory(:not_owned_type) }

    context "with no public resources" do
      before { basic_auth_cleanup }
      before { visit @uri }
      scenario { should_not_have_type(@resource) }
    end

    context "with public resources" do
      before { basic_auth_cleanup }
      before { @resource = Factory(:type_public) }
      before { visit @uri }
      scenario { should_have_type(@resource) }
    end

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        should_have_type(@resource)
        should_not_have_type(@not_owned_resource)
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end
  end


  # GET /types/{type-id}
  context ".show" do
    before { @resource = Factory(:type) }
    before { @uri = "/types/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_type) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when resource is public" do
      before { basic_auth_cleanup }
      before { @resource = Factory(:type_public) }
      before { @uri = "/types/#{@resource.id.as_json}" }
      before { puts "-----------------------" }
      before { visit @uri }
      scenario "view resource" do
        page.status_code.should == 200
        should_have_type(@resource)
        should_have_all_status_connections
        should_have_valid_json(page.body)
      end
    end

    context "when logged in" do
      before { basic_auth(@user) }
      before { visit @uri }

      scenario "view resource" do
        page.status_code.should == 200
        should_have_type(@resource)
        should_have_all_status_connections
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "types"
    end
  end


  # POST /types
  context ".create" do
    before { @uri =  "/types" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ 
        name: Settings.type.name,
        categories: [ Settings.category.uri ],
        properties: [
          Settings.properties.status.uri, 
          Settings.properties.intensity.uri ],
        functions: [
          Settings.functions.set_intensity.uri,
          Settings.functions.turn_on.uri,
          Settings.functions.turn_off.uri ],
        statuses: [
          Settings.statuses.is_setting_max.uri,
          Settings.statuses.has_set_max.uri,
          Settings.statuses.is_setting_intensity.uri,
          Settings.statuses.has_set_intensity.uri ]
        }}

      context "with valid params" do
        before { page.driver.post(@uri, params.to_json) }
        before { @resource = Type.last }

        scenario "create resource" do
          page.status_code.should == 201
          should_have_type(@resource)
          should_have_all_status_connections
          should_have_valid_json(page.body)
        end

        scenario "create default status" do
          default = @resource.type_statuses.where(order: Settings.statuses.default_order).first
          default.should_not be_nil
        end
      end

      context "with not valid params" do
        scenario "get a not valid notification" do
          page.driver.post(@uri, {}.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end

      context "#categories" do
        it_should_behave_like "an array field", "categories", "page.driver.post(@uri, params.to_json)"
      end

      context "#properties" do
        it_should_behave_like "an array field", "properties", "page.driver.post(@uri, params.to_json)"
      end

      context "#functions" do
        it_should_behave_like "an array field", "functions", "page.driver.post(@uri, params.to_json)"
      end
    end
  end


  # PUT /types/{type-id}
  context ".update" do
    before { @resource = Factory(:type) }
    before { @uri = "/types/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_type) }

    it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ 
        name: "Set intensity updated",
        properties: [ 
          Settings.properties.status.uri 
        ],
        functions: [ 
          Settings.functions.turn_on.uri, 
          Settings.functions.turn_off.uri 
        ],
        statuses: [
          Settings.statuses.has_set_intensity.uri,
          Settings.statuses.is_setting_intensity.uri
        ]
      }}

      context "with valid params" do
        before { page.driver.put(@uri, params.to_json) }
        before { @resource.reload }

        scenario "update resource" do
          page.status_code.should == 200
          page.should have_content "updated"
          should_have_type(@resource)
          should_have_valid_json(page.body)
          should_have_property(@status)
          should_have_function(@turn_off)
          should_have_function(@turn_on)
          should_have_status(@has_set_intensity)
          should_have_status(@is_setting_intensity)
        end

        scenario "mantain default status" do
          default = @resource.type_statuses.where(order: Settings.statuses.default_order).first
          default.should_not be_nil
        end

        context "with empty properties" do
          before { params.delete(:properties) }
          before { page.driver.put(@uri, params.to_json) }
          before { @resource.reload }

          scenario "do not delete previous properties" do
            page.status_code.should == 200
            should_have_type(@resource)
            should_have_function(@turn_off)
            should_have_function(@turn_on)
            should_have_valid_json(page.body)
          end
        end
      end

      scenario "not valid params" do
        page.driver.put(@uri, {name: ''}.to_json)
        should_have_a_not_valid_resource
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "types"

      context "#categories" do
        it_should_behave_like "an array field", "categories", "page.driver.put(@uri, params.to_json)"
      end
 
      context "#properties" do
        it_should_behave_like "an array field", "properties", "page.driver.put(@uri, params.to_json)"
      end

      context "#functions" do
        it_should_behave_like "an array field", "functions", "page.driver.put(@uri, params.to_json)"
      end
    end
  end


  # DELETE /types/{type-id}
  context ".destroy" do
    before { @resource = Factory(:type) }
    before { @uri = "/types/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_type) }

    it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 

      scenario "delete the resource" do
        lambda {
          page.driver.delete(@uri)
        }.should change{ Type.count }.by(-1)

        should_have_type(@resource)
        page.status_code.should == 200
        should_have_all_status_connections
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "types"
    end
  end
end


