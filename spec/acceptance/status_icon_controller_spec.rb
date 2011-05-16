require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusIconController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Status.destroy_all }
  before { @resource = Factory(:is_setting_intensity) }
  before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
  before { @image_path = "#{fixture_path}/example.png" }
 
  #GET /statuses/{status-id}/icon
  context ".show" do
    before { @uri = "/statuses/#{@resource.id}/icon" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 

      context "with uploaded image" do
        before { @resource.update_attributes(image: File.new(@image_path)) }
        scenario "redirect to the uploaded image" do
          visit @uri
          @resource.image_url.should_not match /default\.png/
          page.status_code.should == 200
        end

        context "with a valid version" do
          scenario "link the versioned image" do
            visit "#{@uri}?size=micro"
            @resource.image_url.should_not match /micro/
            page.status_code.should == 200
          end
        end

        context "with a not valid version" do
          scenario "get a not valid notification" do
            visit "#{@uri}?size=not_existing"
            should_have_a_not_found_resource("#{@uri}?size=not_existing", "notifications.icon.not_found")
            should_have_valid_json(page.body)
          end
        end
      end

      context "with no uploaded image" do
        scenario "redirect to the default image" do
          visit @uri
          @resource.image_url.should match /default/
          page.status_code.should == 200
        end
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "statuses", "/properties"
    end
  end


  # POST /statuses/{status-id}/icon
  context ".create" do
    before { @uri = "/statuses/#{@resource.id}/icon" }
    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { @file = Rack::Test::UploadedFile.new(@image_path, "image/png") }

      scenario "upload the image" do
        @resource.image_url.should match /default/
        page.driver.post(@uri, {image: @file})
        page.status_code.should == 201
        @resource.reload.image_url.should_not match /default/
      end

      context "with no valid format .jpeg" do
        before { @file = Rack::Test::UploadedFile.new("#{fixture_path}/example.jpg", "image/jpeg") }
        scenario "get not valid notification" do
          page.driver.post(@uri, {image: @file})
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
          save_and_open_page
        end
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "statuses", "/properties"
    end
  end
end
