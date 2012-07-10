require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "TypesController" do
  before { Type.destroy_all }
  before { host! "http://" + host }

  before { @status     = FactoryGirl.create(:status) }
  before { @intensity  = FactoryGirl.create(:intensity) }
  before { @properties = ["#{host}/properties/#{@status._id}", "#{host}/properties/#{@intensity._id}"] }

  before { @turn_on       = FactoryGirl.create(:turn_on) }
  before { @turn_off      = FactoryGirl.create(:turn_off) }
  before { @set_intensity = FactoryGirl.create(:set_intensity) }
  before { @functions     = ["#{host}/functions/#{@turn_on._id}", "#{host}/functions/#{@turn_off._id}", "#{host}/functions/#{@set_intensity._id}"] }

  before { @setting_intensity = FactoryGirl.create(:setting_intensity) }
  before { @statuses          = ["#{host}/statuses/#{@setting_intensity._id}"] }

  before { @lighting   = FactoryGirl.create(:lighting) }
  before { @categories = ["#{host}/statuses/#{@lighting._id}"] }


  # -----------------
  # GET /types
  # -----------------
  context ".index" do
    before { @uri = "/types" }

    before { @resource = FactoryGirl.create(:type, properties: @properties, functions: @functions, statuses: @statuses) }
    before { @resource_not_owned = FactoryGirl.create(:type_not_owned) }

    it_should_behave_like "not authorized resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth }

      it "shows all owned resources" do
        visit @uri
        page.status_code.should == 200
        should_have_owned_type @resource
      end


      # ---------
      # Search
      # ---------
      context "when searching" do
        context "name" do
          before { @name = "My name is type" }
          before { @result = FactoryGirl.create(:type_no_connections, name: @name) }

          it "finds the desired type" do
            visit "#{@uri}?name=name+is"
            should_contain_type @result
            page.should_not have_content @resource.name
          end
        end
      end


      # ------------
      # Pagination
      # ------------
      context "when paginating" do
        before { Type.destroy_all }
        before { @resource = TypeDecorator.decorate(FactoryGirl.create(:type_no_connections)) }
        before { @resources = FactoryGirl.create_list(:type, Settings.pagination.per + 5, name: 'Extra type') }

        context "with :start" do
          it "shows the next page" do
            visit "#{@uri}?start=#{@resource.uri}"
            page.status_code.should == 200
            should_contain_type @resources.first
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
              JSON.parse(page.source).should have(Type.count).items
            end
          end
        end
      end
    end
  end



  # ---------------------
  # GET /types/:id
  # ---------------------
  context ".show" do
    before { @resource = TypeDecorator.decorate(FactoryGirl.create(:type, properties: @properties, functions: @functions, statuses: @statuses, categories: @categories)) }
    before { @uri = "/types/#{@resource.id.as_json}" }
    before { @resource_not_owned = FactoryGirl.create(:type_not_owned) }

    it_should_behave_like "not authorized resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth }

      it "view the owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_type @resource
      end

      context "when checking connections" do
        before { visit @uri }

        it "has properties" do
          page.should have_content('"name":"Status"')
        end

        it "has functions" do
          page.should have_content('"name":"Set intensity"')
        end

        it "has properties" do
          page.should have_content('"name":"Setting intensity"')
        end

        it "has properties" do
          page.should have_content('"name":"Lighting"')
        end
      end

      it "exposes the type URI" do
        visit @uri
        uri = "http://www.example.com/types/#{@resource.id.as_json}"
        @resource.uri.should == uri
      end

      context "with host" do
        it "changes the URI" do
          visit "#{@uri}?host=www.lelylan.com"
          @resource.uri.should match("http://www.lelylan.com/")
        end
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "types"
    end
  end



  # ---------------
  # POST /types
  # ---------------
  context ".create" do
    before { @uri =  "/types" }

    it_should_behave_like "not authorized resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth }
      before { @params = { name: 'Type created', properties: @properties, functions: @functions, statuses: @statuses } }

      it "creates the resource" do
        page.driver.post @uri, @params.to_json
        @resource = Type.last
        page.status_code.should == 201
        should_have_type @resource
      end

      it "creates the resource connections" do
        page.driver.post @uri, @params.to_json
        @resource = Type.last
        @resource.property_ids.should have(2).items
        @resource.function_ids.should have(3).items
        @resource.status_ids.should have(1).items
      end

      it "stores the resource" do
        expect{ page.driver.post(@uri, @params.to_json) }.to change{ Type.count }.by(1)
      end

      it_validates "not valid params", "page.driver.post(@uri, @params.to_json)", { method: "POST", error: "Name can't be blank" }
      it_validates "not valid JSON", "page.driver.post(@uri, @params.to_json)", { method: "POST" }
    end
  end



  # ---------------------
  # PUT /types/:id
  # ---------------------
  context ".update" do
    before { @resource = FactoryGirl.create(:type, properties: @properties, functions: @functions) }
    before { @uri = "/types/#{@resource.id.as_json}" }
    before { @resource_not_owned = FactoryGirl.create(:type_not_owned) }

    it_should_behave_like "not authorized resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth }
      before { @params = { name: 'Updated', statuses: @statuses } }

      it "updates the resource" do
        page.driver.put @uri, @params.to_json
        @resource.reload
        page.status_code.should == 200
        page.should have_content "Updated"
      end

      it "updates the resource properties" do
        page.driver.put @uri, @params.to_json
        page.should_not have_content '"statuses":[]'
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "types"
      it_validates "not valid JSON", "page.driver.put(@uri, @params.to_json)", { method: "PUT" }
    end
  end



  # ------------------------
  # DELETE /types/:id
  # ------------------------
  context ".destroy" do
    before { @resource = FactoryGirl.create(:type_no_connections) }
    before { @uri =  "/types/#{@resource.id.as_json}" }
    before { @resource_not_owned = FactoryGirl.create(:type_not_owned) }

    it_should_behave_like "not authorized resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth } 

      scenario "delete resource" do
        expect{ page.driver.delete(@uri) }.to change{ Type.count }.by(-1)
        page.status_code.should == 200
        should_have_type @resource
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "types"
    end
  end
end
