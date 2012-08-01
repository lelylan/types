require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "CategoriesController" do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, application: application, scopes: 'write', resource_owner_id: user.id }

  before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }

  describe 'GET /locations' do

    let!(:resource)  { FactoryGirl.create :category, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :category }
    let(:uri)        { '/categories' }

    it 'shows all owned resources' do
      page.driver.get uri
      page.status_code.should == 200
      contains_owned_category resource
    end

    it_behaves_like 'searchable', 'category', { name: 'My name is resource' }

    it_behaves_like 'paginable', 'category'
  end

  #context 'GET /locations/:id' do

    #let!(:resource)  { FactoryGirl.create(:floor, :with_ancestors, :with_descendants, :with_devices, resource_owner_id: user.id) }
    #let!(:not_owned) { FactoryGirl.create(:floor) }
    #let(:uri)        { "/locations/#{resource.id}" }

    #before { page.driver.get uri }

    #it 'view the owned resource' do
      #page.status_code.should == 200
      #has_location resource
    #end

    #it 'creates the resource connections' do
      #json = Hashie::Mash.new JSON.parse(page.source)
      #json.parent.should_not == nil
      #json.ancestors.should have(2).itmes
      #json.locations.should have(1).item
      #json.devices.should   have(1).items
    #end

    #it_behaves_like 'changeable host'
    #it_behaves_like 'not found resource', 'page.driver.get(uri)'
  #end

  #context 'POST /locations' do

    #let!(:uri) { '/locations' }
    #before     { page.driver.get uri } # let us use the decorators before calling the POST method

    #let(:parent) { FactoryGirl.create(:house, resource_owner_id: user.id) }
    #let(:child)  { FactoryGirl.create(:room, resource_owner_id: user.id) }
    #let(:device) { FactoryGirl.create(:device, resource_owner_id: user.id) }

    #let(:params) {{
      #name:      'New floor',
      #type:      'floor',
      #parent:    LocationDecorator.decorate(parent).uri, 
      #locations: [ LocationDecorator.decorate(child).uri ],
      #devices:   [ DeviceDecorator.decorate(device).uri ]
    #}}

    #before         { page.driver.post uri, params.to_json }
    #let(:resource) { Location.last }

    #it 'creates the resource' do
      #page.driver.post uri, params.to_json
      #resource = Location.last
      #page.status_code.should == 201
      #has_location resource
    #end

    #it 'creates the resource connections' do
      #resource.the_parent.should_not == nil
      #resource.ancestors.should      have(1).itmes
      #resource.children.should       have(1).item
      #resource.descendants.should    have(1).items
    #end

    #it 'stores the resource' do
      #expect { page.driver.post(uri, params.to_json) }.to change { Location.count }.by(1)
    #end

    #it_behaves_like 'check valid params', 'page.driver.post(uri, {}.to_json)', { method: 'POST', error: "Name can't be blank" }
    #it_behaves_like 'not valid json input', 'page.driver.post(uri, params.to_json)', { method: 'POST' }
  #end

  #context 'PUT /locations/:id' do

    #before { page.driver.get '/locations' } # let us use the decorators before calling the POST method

    #let!(:resource)  { FactoryGirl.create :floor, :with_parent, :with_children, resource_owner_id: user.id }
    #let!(:new_house) { FactoryGirl.create :house, name: 'New house', resource_owner_id: user.id }
    #let!(:new_room)  { FactoryGirl.create :room, name: 'New Room', resource_owner_id: user.id }
    #let!(:not_owned) { FactoryGirl.create(:floor) }

    #let(:uri) { "/locations/#{resource.id}" }

    #let(:params) {{
      #name:      'New floor', 
      #parent:    LocationDecorator.decorate(new_house).uri, 
      #locations: [LocationDecorator.decorate(new_room).uri] 
    #}}

    #before { page.driver.put uri, params.to_json }
    #before { resource.reload }

    #it 'updates the resource' do
      #page.status_code.should == 200
      #page.should have_content 'New'
      #has_location resource
    #end

    #it 'updates the resource connections' do
      #resource.the_parent.should     == new_house.reload
      #resource.children.first.should == new_room.reload
    #end

    #it_behaves_like 'not found resource', 'page.driver.put(uri)'
    #it_behaves_like 'check valid params', 'page.driver.put(uri, {name: ""}.to_json)', { method: 'PUT', error: "Name can't be blank" }
    #it_behaves_like 'not valid json input', 'page.driver.put(uri, params.to_json)', { method: 'PUT' }
  #end

  #context 'DELETE /locations/:id' do
    #let!(:resource)  { FactoryGirl.create :floor, :with_ancestors, :with_descendants, resource_owner_id: user.id }
    #let!(:not_owned) { FactoryGirl.create(:floor) }
    #let(:uri)        { "/locations/#{resource.id}" }

    #it 'deletes resource' do
      #expect { page.driver.delete(uri) }.to change{ Location.count }.by(-1)
      #page.status_code.should == 200
      #has_location resource
    #end

    #it_behaves_like 'not found resource',   'page.driver.delete(uri)'
  #end
end

  #context ".index" do
    #before { @uri = "/categories" }
    #before { @resource = FactoryGirl.create(:category) }
    #before { @resource_not_owned = FactoryGirl.create(:category_not_owned) }

    #it_should_behave_like "not authorized resource", "visit(@uri)"

    #context "when logged in" do
      #before { basic_auth }

      #it "shows all owned resources" do
        #visit @uri
        #page.status_code.should == 200
        #should_have_owned_category @resource
      #end


      ## ---------
      ## Search
      ## ---------
      #shared_examples "searching category" do
        #context "name" do
          #before { @name = "My name is category" }
          #before { @result = FactoryGirl.create(:category, name: @name) }

          #it "finds the desired category" do
            #visit "#{@uri}?name=name+is"
            #should_contain_category @result
            #page.should_not have_content @resource.name
          #end
        #end
      #end


      ## ------------
      ## Pagination
      ## ------------
      #shared_examples "paginating category" do
        #before { Category.destroy_all }
        #before { @resource = CategoryDecorator.decorate(FactoryGirl.create(:category)) }
        #before { @resources = FactoryGirl.create_list(:category, Settings.pagination.per + 5, name: 'Extra category') }

        #context "with :start" do
          #it "shows the next page" do
            #visit "#{@uri}?start=#{@resource.uri}"
            #page.status_code.should == 200
            #should_contain_category @resources.first
            #page.should_not have_content @resource.name
          #end
        #end

        #context "with :per" do
          #context "when not set" do
            #it "shows the default number of resources" do
              #visit "#{@uri}"
              #JSON.parse(page.source).should have(Settings.pagination.per).items
            #end
          #end

          #context "when set to 5" do
            #it "shows 5 resources" do
              #visit "#{@uri}?per=5"
              #JSON.parse(page.source).should have(5).items
            #end
          #end

          #context "when set too high value" do
            #before { Settings.pagination.max_per = 30 }

            #it "shows the max number of resources allowed" do
              #visit "#{@uri}?per=100000"
              #JSON.parse(page.source).should have(30).items
            #end
          #end

          #context "when set to not valid value" do
            #it "shows the default number of resources" do
              #visit "#{@uri}?per=not_valid"
              #JSON.parse(page.source).should have(Settings.pagination.per).items
            #end
          #end
        #end
      #end
    #end
  #end



  ## -----------------------
  ## GET /categories/public
  ## -----------------------
  #context ".index" do
    #before { @uri = "/categories/public" }
    #before { @resource = FactoryGirl.create(:category) }
    #before { @resource_not_owned = FactoryGirl.create(:category_not_owned) }

    #context "when not logged in" do
      #it "shows all owned and not owned resources" do
        #visit @uri
        #page.status_code.should == 200
        #JSON.parse(page.source).should have(2).items
      #end
    #end

    #context "when logged in" do
      #before { basic_auth }

      #it "shows all owned and not owned resources" do
        #visit @uri
        #page.status_code.should == 200
        #JSON.parse(page.source).should have(2).items
      #end

      #it_should_behave_like "searching category"
      #it_should_behave_like "paginating category"
    #end
  #end



  ## ---------------------
  ## GET /categories/:id
  ## ---------------------
  #context ".show" do
    #before { @resource = CategoryDecorator.decorate(FactoryGirl.create(:category)) }
    #before { @uri = "/categories/#{@resource.id.as_json}" }
    #before { @resource_not_owned = FactoryGirl.create(:category_not_owned) }

    #context "when not logged in" do
      #it "views the owned resource" do
        #visit @uri
        #page.status_code.should == 200
        #should_have_category @resource
      #end
    #end

    #context "when logged in" do
      #before { basic_auth }

      #it "views the owned resource" do
        #visit @uri
        #page.status_code.should == 200
        #should_have_category @resource
      #end

      #it "exposes the category URI" do
        #visit @uri
        #uri = "http://www.example.com/categories/#{@resource.id.as_json}"
        #@resource.uri.should == uri
      #end

      #context "with host" do
        #it "changes the URI" do
          #visit "#{@uri}?host=www.lelylan.com"
          #@resource.uri.should match("http://www.lelylan.com/")
        #end
      #end

      #context "with public resources" do
        #before { @uri = "/categories/#{@resource_not_owned._id}" }

        #it "view the not owned resource" do
          #visit @uri
          #page.status_code.should == 200
          #should_have_category @resource_not_owned
        #end
      #end
    #end
  #end



  ## ---------------
  ## POST /categories
  ## ---------------
  #context ".create" do
    #before { @uri =  "/categories" }

    #it_should_behave_like "not authorized resource", "page.driver.post(@uri)"

    #context "when logged in" do
      #before { basic_auth }
      #before { @params = { name: 'Lighting' } }

      #it "creates the resource" do
        #page.driver.post @uri, @params.to_json
        #@resource = Category.last
        #page.status_code.should == 201
        #should_have_category @resource
      #end

      #it "stores the resource" do
        #expect{ page.driver.post(@uri, @params.to_json) }.to change{ Category.count }.by(1)
      #end

      #context "with not valid params" do
        #before { @params[:name] = "" }

        #it "does not create the resource" do
          #expect{ page.driver.post(@uri, @params.to_json) }.to change{ Function.count }.by(0)
        #end
      #end

      #it_validates "not valid params", "page.driver.post(@uri, @params.to_json)", { method: "POST", error: "Name can't be blank" }
      #it_validates "not valid JSON", "page.driver.post(@uri, @params.to_json)", { method: "POST" }
    #end
  #end



  ## ---------------------
  ## PUT /categories/:id
  ## ---------------------
  #context ".update" do
    #before { @resource = FactoryGirl.create(:category) }
    #before { @uri = "/categories/#{@resource.id.as_json}" }
    #before { @resource_not_owned = FactoryGirl.create(:category_not_owned) }

    #it_should_behave_like "not authorized resource", "page.driver.put(@uri)"

    #context "when logged in" do
      #before { basic_auth }
      #before { @params = { name: 'Updated' } }

      #it "updates a resource" do
        #page.driver.put @uri, @params.to_json
        #@resource.reload
        #page.status_code.should == 200
        #page.should have_content "Updated"
      #end

      #it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "categories"
      #it_validates "not valid JSON", "page.driver.put(@uri, @params.to_json)", { method: "PUT" }
    #end
  #end



  ## ------------------------
  ## DELETE /categories/:id
  ## ------------------------
  #context ".destroy" do
    #before { @resource = FactoryGirl.create(:category) }
    #before { @uri =  "/categories/#{@resource.id.as_json}" }
    #before { @resource_not_owned = FactoryGirl.create(:category_not_owned) }

    #it_should_behave_like "not authorized resource", "page.driver.delete(@uri)"

    #context "when logged in" do
      #before { basic_auth } 

      #scenario "delete resource" do
        #expect{ page.driver.delete(@uri) }.to change{ Category.count }.by(-1)
        #page.status_code.should == 200
        #should_have_category @resource
      #end

      #it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "categories"
    #end
  #end
#end
