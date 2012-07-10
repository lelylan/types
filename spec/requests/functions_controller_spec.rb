require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "FunctionsController" do
  before { Function.destroy_all }
  before { host! "http://" + host }


  # -----------------
  # GET /functions
  # -----------------
  context ".index" do
    before { @uri = "/functions" }
    before { @resource = FactoryGirl.create(:function) }
    before { @resource_not_owned = FactoryGirl.create(:function_not_owned) }

    it_should_behave_like "not authorized resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth }

      it "shows all owned resources" do
        visit @uri
        page.status_code.should == 200
        should_have_owned_function @resource
      end


      # ---------
      # Search
      # ---------
      context "when searching" do
        context "name" do
          before { @name = "My name is function" }
          before { @result = FactoryGirl.create(:function, name: @name) }

          it "finds the desired function" do
            visit "#{@uri}?name=name+is"
            should_contain_function @result
            page.should_not have_content @resource.name
          end
        end
      end


      # ------------
      # Pagination
      # ------------
      context "when paginating" do
        before { Function.destroy_all }
        before { @resource = FunctionDecorator.decorate(FactoryGirl.create(:function)) }
        before { @resources = FactoryGirl.create_list(:function, Settings.pagination.per + 5, name: 'Extra function') }

        context "with :start" do
          it "shows the next page" do
            visit "#{@uri}?start=#{@resource.uri}"
            page.status_code.should == 200
            should_contain_function @resources.first
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
              JSON.parse(page.source).should have(Function.count).items
            end
          end
        end
      end
    end
  end



  # ---------------------
  # GET /functions/:id
  # ---------------------
  context ".show" do
    before { @resource = FunctionDecorator.decorate(FactoryGirl.create(:function)) }
    before { @uri = "/functions/#{@resource.id.as_json}" }
    before { @resource_not_owned = FactoryGirl.create(:function_not_owned) }

    it_should_behave_like "not authorized resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth }

      it "views the owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_function @resource
      end

      it "exposes the function URI" do
        visit @uri
        uri = "http://www.example.com/functions/#{@resource.id.as_json}"
        @resource.uri.should == uri
      end

      context "with host" do
        it "changes the URI" do
          visit "#{@uri}?host=www.lelylan.com"
          @resource.uri.should match("http://www.lelylan.com/")
        end
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "functions"
    end
  end



  # ----------------
  # POST /functions
  # ----------------
  context ".create" do
    before { @uri =  "/functions" }

    it_should_behave_like "not authorized resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth }
      before { @properties = json_fixture('properties.json')[:properties] }
      before { @params = { name: 'New set intensity', properties: @properties } }

      it "creates the resource" do
        page.driver.post @uri, @params.to_json
        @resource = Function.last
        page.status_code.should == 201
        should_have_function @resource
      end

      it "creates the resource connections" do
        page.driver.post @uri, @params.to_json
        @resource = Function.last
        @resource.properties.should have(2).items
      end

      it "saves the resource" do
        expect{ page.driver.post(@uri, @params.to_json) }.to change{ Function.count }.by(1)
      end

      context "with not valid params" do
        before { @params[:name] = "" }

        it "does not create the resource" do
          expect{ page.driver.post(@uri, @params.to_json) }.to change{ Function.count }.by(0)
        end
      end

      it_validates "not valid params", "page.driver.post(@uri, @params.to_json)", { method: "POST", error: "Name can't be blank" }
      it_validates "not valid JSON", "page.driver.post(@uri, @params.to_json)", { method: "POST" }
    end
  end



  # ---------------------
  # PUT /functions/:id
  # ---------------------
  context ".update" do
    before { @resource = FactoryGirl.create(:function) }
    before { @uri = "/functions/#{@resource.id.as_json}" }
    before { @resource_not_owned = FactoryGirl.create(:function_not_owned) }

    it_should_behave_like "not authorized resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth }
      before { @properties = json_fixture('properties.json')[:properties] }
      before { @params = { name: 'Updated', properties: @properties } }

      it "updates the resource" do
        page.driver.put @uri, @params.to_json
        @resource.reload
        page.status_code.should == 200
        page.should have_content "Updated"
      end

      it "updates the resource properties" do
        page.driver.put @uri, @params.to_json
        page.should have_content "on"
        page.should have_content "100"
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "functions"
      it_validates "not valid JSON", "page.driver.put(@uri, @params.to_json)", { method: "PUT" }
    end
  end



  # ------------------------
  # DELETE /functions/:id
  # ------------------------
  context ".destroy" do
    before { @resource = FactoryGirl.create(:function) }
    before { @uri =  "/functions/#{@resource.id.as_json}" }
    before { @resource_not_owned = FactoryGirl.create(:function_not_owned) }

    it_should_behave_like "not authorized resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth } 

      scenario "delete resource" do
        expect{ page.driver.delete(@uri) }.to change{ Function.count }.by(-1)
        page.status_code.should == 200
        should_have_function @resource
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "functions"
    end
  end
end
