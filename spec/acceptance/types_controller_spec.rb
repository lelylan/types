require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "TypeController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Type.destroy_all }
  before { Property.destroy_all }
  before { Function.destroy_all }

  before { @status = Factory(:property_status) }
  before { @intensity = Factory(:property_intensity) }
  before { @set_intensity = Factory(:set_intensity) }
  before { @turn_on = Factory(:turn_on) }
  before { @turn_off = Factory(:turn_off) }


  # GET /types
  context ".index" do
    before { @uri = "/types?page=1&per=100" }
    before { @resource = Factory(:type) }
    before { @not_owned_resource = Factory(:not_owned_type) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      scenario "view all resources" do
        page.status_code.should == 200
        save_and_open_page
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

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_type(@resource)
        should_have_property(@status)
        should_have_property(@intensity)
        should_have_function(@set_intensity)
        should_have_function(@turn_off)
        should_have_function(@turn_on)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "rescued when resource not found", 
                            "visit @uri", "types"
    end
  end


  ## POST /types
  #context ".create" do
    #before { @uri =  "/types" }

    #it_should_behave_like "protected resource", "page.driver.post(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #let(:params) {{ 
        #name: Settings.types.name,
        #properties: [
          #Settings.properties.status.uri, 
          #Settings.properties.intensity.uri ],
        #functions: [
          #Settings.functions.set_intensity.uri,
          #Settings.functions.turn_on.uri,
          #Settings.functions.turn_off.uri ]
      #}}

      #scenario "create resource" do
        #page.driver.post(@uri, params.to_json)
        #@resource = Type.last
        #page.status_code.should == 201
        #should_have_type(@resource)
        #should_have_valid_json(page.body)
      #end

      #context "with not valid params" do
        #scenario "get a not valid notification" do
          #page.driver.post(@uri, {}.to_json)
          #should_have_a_not_valid_resource
          #should_have_valid_json(page.body)
        #end
      #end

      #context "#properties" do
        #it_should_behave_like "an array field", "properties", "page.driver.post(@uri, params.to_json)"
      #end

      #context "#functions" do
        #it_should_behave_like "an array field", "functions", "page.driver.post(@uri, params.to_json)"
      #end
    #end
  #end


  ## PUT /types/{type-id}
  #context ".update" do
    #before { @resource = Factory(:type) }
    #before { @uri =  "/types/#{@resource.id.as_json}" }
    #before { @not_owned_resource = Factory(:not_owned_type) }

    #it_should_behave_like "protected resource", "page.driver.put(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #let(:params) {{ 
        #name: "Set intensity updated",
        #properties: [ Settings.properties.status.uri ],
        #functions: [ Settings.functions.turn_on.uri, Settings.functions.turn_off.uri ]
      #}}

      #scenario "create resource" do
        #page.driver.put(@uri, params.to_json)
        #page.status_code.should == 200
        #should_have_type(@resource.reload)
        #page.should have_content "updated"
        #should_have_valid_json(page.body)
      #end

      #scenario "not valid params" do
        #page.driver.put(@uri, {name: ''}.to_json)
        #should_have_a_not_valid_resource
      #end

      #it_should_behave_like "rescued when resource not found",
                            #"page.driver.put(@uri)", "types"

      #context "#properties" do
        #it_should_behave_like "an array field", "properties", "page.driver.post(@uri, params.to_json)"
      #end

      #context "#functions" do
        #it_should_behave_like "an array field", "functions", "page.driver.post(@uri, params.to_json)"
      #end
    #end
  #end


  ## DELETE /types/{type-id}
  #context ".destroy" do
    #before { @resource = Factory(:type) }
    #before { @uri =  "/types/#{@resource.id.as_json}" }
    #before { @not_owned_resource = Factory(:not_owned_type) }

    #it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    #context "when logged in" do
      #before { basic_auth(@user) } 
      #scenario "delete resource" do
        #lambda {
          #page.driver.delete(@uri, {}.to_json)
        #}.should change{ Type.count }.by(-1)
        #page.status_code.should == 200
        #should_have_type(@resource)
        #should_have_valid_json(page.body)
      #end

      #it_should_behave_like "rescued when resource not found",
                            #"page.driver.delete(@uri)", "types"
    #end
  #end

end


