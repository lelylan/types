require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "PropertiesController" do
  before { Property.destroy_all }
  before { host! "http://" + host }


  # -----------------
  # GET /properties
  # -----------------
  context ".index" do
    before { @uri = "/properties" }
    before { @resource = FactoryGirl.create(:property) }
    before { @resource_not_owned = FactoryGirl.create(:property_not_owned) }

    it_should_behave_like "not authorized resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth }

      it "shows all owned resources" do
        visit @uri
        page.status_code.should == 200
        should_have_owned_property @resource
      end


      # ---------
      # Search
      # ---------
      context "when searching" do
        context "name" do
          before { @name = "My name is property" }
          before { @result = FactoryGirl.create(:property, name: @name) }

          it "finds the desired property" do
            visit "#{@uri}?name=name+is"
            should_contain_property @result
            page.should_not have_content @resource.name
          end
        end
      end


      # ------------
      # Pagination
      # ------------
      context "when paginating" do
        before { Property.destroy_all }
        before { @resource = PropertyDecorator.decorate(FactoryGirl.create(:property)) }
        before { @resources = FactoryGirl.create_list(:property, Settings.pagination.per + 5, name: 'Extra property') }

        context "with :start" do
          it "shows the next page" do
            visit "#{@uri}?start=#{@resource.uri}"
            save_and_open_page
            page.status_code.should == 200
            should_contain_property @resources.first
            page.should_not have_content @resource.name
          end
        end

        context "with :per" do
          context "when not set" do
            it "shows the default number of resources" do
              visit "#{@uri}"
              JSON.parse(page.source).should have(Settings.pagination.per).items
            end
          end

          context "when set to 5" do
            it "shows 5 resources" do
              visit "#{@uri}?per=5"
              JSON.parse(page.source).should have(5).items
            end
          end

          context "when set to all" do
            it "shows all resources" do
              visit "#{@uri}?per=all"
              JSON.parse(page.source).should have(Property.count).items
            end
          end
        end
      end
    end
  end



  ## ------------------
  ## GET /properties/:id
  ## ------------------
  #context ".show" do
    #before { @resource = PropertyDecorator.decorate(FactoryGirl.create(:property)) }
    #before { @uri = "/properties/#{@resource.id.as_json}" }
    #before { @resource_not_owned = FactoryGirl.create(:property_not_owned) }

    #it_should_behave_like "not authorized resource", "visit(@uri)"

    #context "when logged in" do
      #before { basic_auth }

      #it "should view owned resource" do
        #visit @uri
        #page.status_code.should == 200
        #should_have_property @resource
      #end

      #it "should expose the property URI" do
        #visit @uri
        #uri = "http://www.example.com/properties/#{@resource.id.as_json}"
        #@resource.uri.should == uri
      #end

      #context "with host" do
        #it "should change the URI" do
          #visit "#{@uri}?host=www.lelylan.com"
          #@resource.uri.should match("http://www.lelylan.com/")
        #end
      #end

      #it_should_behave_like "a rescued 404 resource", "visit @uri", "properties"
    #end
  #end



  ## ---------------
  ## POST /properties
  ## ---------------
  #context ".create" do
    #before { @uri =  "/properties" }
    #before { stub_get(Settings.type.uri).to_return(body: fixture('type.json')) }

    #it_should_behave_like "not authorized resource", "page.driver.post(@uri)"

    #context "when logged in" do
      #before { basic_auth }
      #before { @params = { name: 'New closet dimmer', type_uri: Settings.type.uri, physical: {uri: Settings.physical.uri} } }

      #it "should create a resource" do
        #page.driver.post @uri, @params.to_json
        #@resource = Property.last
        #page.status_code.should == 201
        #should_have_property @resource
      #end

      #context "when Lelylan Type" do
        ## Reload the before_create function (removed in the property factory to have the desired properties)
        #before { Property.before_create :synchronize_type }

        #context "returns unauthorized access" do
          #before { @params[:type_uri] = @params[:type_uri] + "-401" }
          #before { stub_get(@params[:type_uri]).to_return(status: 401, body: fixture('errors/401.json')) }

          #it "should not create a resource" do
            #page.driver.post @uri, @params.to_json
            #code = 'notifications.type.unauthorized'
            #should_have_a_not_valid_resource code: code, error: I18n.t(code)
          #end
        #end

        #context "returns not found resource" do
          #before { @params[:type_uri] = @params[:type_uri] + "-404" }
          #before { stub_get(@params[:type_uri]).to_return(status: 404, body: fixture('errors/404.json')) }

          #it "should not create a resource" do
            #page.driver.post @uri, @params.to_json
            #code = 'notifications.type.not_found'
            #should_have_a_not_valid_resource code: code, error: I18n.t(code)
          #end
        #end

        #context "returns technically wrong error" do
          #before { @params[:type_uri] = @params[:type_uri] + "-500" }
          #before { stub_get(@params[:type_uri]).to_return(status: 500, body: fixture('errors/500.json')) }

          #it "should not create a resource" do
            #page.driver.post @uri, @params.to_json
            #code = 'notifications.type.error'
            #should_have_a_not_valid_resource code: code, error: I18n.t(code)
          #end
        #end

        #context "returns service over capacity" do
          #before { @params[:type_uri] = @params[:type_uri] + "-503" }
          #before { stub_get(@params[:type_uri]).to_return(status: 503, body: fixture('errors/503.json')) }

          #it "should not create a resource" do
            #page.driver.post @uri, @params.to_json
            #code = 'notifications.type.unavailable'
            #should_have_a_not_valid_resource code: code, error: I18n.t(code)
          #end
        #end
      #end

      #it_validates "not valid params", "page.driver.post(@uri, @params.to_json)", "POST"
      #it_validates "not valid JSON", "page.driver.post(@uri, @params.to_json)", "POST"
    #end
  #end



  ## ------------------
  ## PUT /properties/:id
  ## ------------------
  #context ".update" do
    #before { @resource = FactoryGirl.create(:property) }
    #before { @uri = "/properties/#{@resource.id.as_json}" }
    #before { @resource_not_owned = FactoryGirl.create(:property_not_owned) }

    #it_should_behave_like "not authorized resource", "page.driver.put(@uri)"

    #context "when logged in" do
      #before { basic_auth }
      #before { @params = { name: "Closet dimmer updated", physical: {uri: Settings.physical.uri + '-updated'} } }

      #it "should update a resource" do
        #page.driver.put @uri, @params.to_json
        #@resource.reload
        #page.status_code.should == 200
        #page.should have_content "Closet dimmer updated"
        #page.should have_content Settings.physical.uri + "-updated"
      #end

      #context "when changing type_uri" do
        #it "should ignore type_uri" do
          #@params[:type_uri] = Settings.type.another.uri
          #page.driver.put @uri, @params.to_json
          #page.should_not have_content Settings.type.another.uri
        #end
      #end

      #it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "properties"
      #it_validates "not valid JSON", "page.driver.put(@uri, @params.to_json)", "PUT"
    #end
  #end



  ## ---------------------
  ## DELETE /properties/:id
  ## ---------------------
  #context ".destroy" do
    #before { @resource = FactoryGirl.create(:property) }
    #before { @uri =  "/properties/#{@resource.id.as_json}" }
    #before { @resource_not_owned = FactoryGirl.create(:property_not_owned) }

    #it_should_behave_like "not authorized resource", "page.driver.delete(@uri)"

    #context "when logged in" do
      #before { basic_auth } 

      #scenario "delete resource" do
        #expect{page.driver.delete(@uri, {}.to_json)}.to change{Property.count}.by(-1)
        #page.status_code.should == 200
        #should_have_property @resource
      #end

      #it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "properties"
    #end
  #end

end
