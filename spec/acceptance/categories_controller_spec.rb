require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "CategoryController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Category.destroy_all }


  # GET /categories
  context ".index" do
    before { @uri = "/categories" }
    before { @resource = Factory(:category) }
    before { @public_resource = Factory(:category_public) }
    before { @not_owned_resource = Factory(:not_owned_category) }
    before { @not_owned_public_resource= Factory(:not_owned_public_category) }

    context "when logged in" do
      before { basic_auth(@user) } 
      before { visit @uri }
      #before { save_and_open_page }
      scenario "view all owned resources" do
        page.status_code.should == 200
        should_have_category(@resource)
        should_have_category(@public_resource)
        should_not_have_category(@not_owned_resource)
        should_not_have_category(@not_owned_public_resource)
        should_have_pagination(@uri)
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end

    # GET categories/public
    context "with public resources" do
      before { basic_auth_cleanup }
      before { visit "#{@uri}/public" }
      scenario "view all public resources" do
        should_have_category(@public_resource)
        should_have_category(@not_owned_public_resource)
        should_not_have_category(@resource)
        should_not_have_category(@not_owned_resource)
        should_have_pagination("#{@uri}/public")
        should_have_valid_json(page.body)
        should_have_root_as('resources')
      end
    end
  end


  # GET /categories/{category-id}
  context ".show" do
    before { @resource = Factory(:category) }
    before { @uri = "/categories/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_category) }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when resource is public" do
      before { basic_auth_cleanup }
      before { @resource = Factory(:not_owned_public_category) }
      before { @uri = "/categories/#{@resource.id.as_json}" }
      scenario "view resource" do
        visit @uri
        save_and_open_page
        page.status_code.should == 200
        should_have_category(@resource)
        should_have_valid_json(page.body)
      end

      context "when logged in" do
        before { basic_auth(@user) } 
        scenario "view resource" do
          visit @uri
          page.status_code.should == 200
          should_have_category(@resource)
          should_have_valid_json(page.body)
        end
      end
    end

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "view owned resource" do
        visit @uri
        page.status_code.should == 200
        should_have_category(@resource)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "categories"
    end
  end


  # POST /categories
  context ".create" do
    before { @uri =  "/categories" }

    it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: Settings.category.name }} 

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        @resource = Category.last
        page.status_code.should == 201
        should_have_category(@resource)
        should_have_valid_json(page.body)
      end

      context "with not valid params" do
        scenario "get a not valid notification" do
          page.driver.post(@uri, {}.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end
    end
  end


  # PUT /categories/{category-id}
  context ".update" do
    before { @resource = Factory(:category) }
    before { @uri =  "/categories/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_category) }

    it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      let(:params) {{ name: "Set category updated" }}

      scenario "create resource" do
        page.driver.put(@uri, params.to_json)
        page.status_code.should == 200
        should_have_category(@resource.reload)
        page.should have_content "updated"
        should_have_valid_json(page.body)
      end

      scenario "not valid params" do
        page.driver.put(@uri, {name: ''}.to_json)
        should_have_a_not_valid_resource
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.put(@uri)", "categories"
    end
  end


  # DELETE /categories/{category-id}
  context ".destroy" do
    before { @resource = Factory(:category) }
    before { @uri =  "/categories/#{@resource.id.as_json}" }
    before { @not_owned_resource = Factory(:not_owned_category) }

    it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      scenario "delete resource" do
        lambda {
          page.driver.delete(@uri, {}.to_json)
        }.should change{ Category.count }.by(-1)
        page.status_code.should == 200
        should_have_category(@resource)
        should_have_valid_json(page.body)
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "categories"
    end
  end

end


