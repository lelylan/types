require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusImageController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Status.destroy_all }
  before { @resource = Factory(:is_setting_intensity) }
  before { @not_owned_resource = Factory(:not_owned_is_setting_intensity) }
  before { @image_path = "#{fixture_path}/example.png" }
  before { ImageUploader.enable_processing = true } 

  #GET /statuses/{status-id}/image
  context ".show" do
    before { @uri = "/statuses/#{@resource.id}/image" }

    it_should_behave_like "protected resource", "visit(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 

      context "with uploaded image" do
        before { @resource.update_attributes(image: File.new(@image_path)) }
        scenario "redirect to the uploaded image" do
          visit @uri
          current_url.should_not match /default/
          page.status_code.should == 200
        end

        context "with a valid version" do
          scenario "link the versioned image" do
            visit "#{@uri}?size=micro"
            current_url.should match /micro/
            page.status_code.should == 200
          end
        end

        context "with a not valid version" do
          scenario "get a not valid notification" do
            visit "#{@uri}?size=not_existing"
            should_have_a_not_found_resource("#{@uri}?size=not_existing", "notifications.image.not_found")
            should_have_valid_json(page.body)
          end
        end
      end

      context "with no uploaded image" do
        scenario "redirect to the default image" do
          visit @uri
          current_url.should match /default/
          page.status_code.should == 200
        end
      end

      it_should_behave_like "a rescued 404 resource", "visit @uri", "statuses", "/image"
    end
  end


  # PUT /statuses/{status-id}/image
  context ".update" do
    before { @uri = "/statuses/#{@resource.id}/image" }
    #it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 
      before { @file = Rack::Test::UploadedFile.new(@image_path, "image/png") }

      scenario "upload the image" do
        @resource.image_url.should match /default/
        page.driver.put(@uri, {image: @file})
        page.status_code.should == 201
        @resource.reload.image_url.should_not match /default/
        File.exist?("#{Rails.root}/public#{@resource.reload.image_url}").should be_true 
      end

      context "with no valid format .jpeg" do
        before { @file = Rack::Test::UploadedFile.new("#{fixture_path}/example.jpg", "image/jpeg") }
        scenario "get not valid notification" do
          page.driver.putt(@uri, {image: @file})
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.putt(@uri)", "statuses", "/image"
    end
  end


  #DELETE /statuses/{status-id}/image
  context ".destroy" do
    before { @uri = "/statuses/#{@resource.id}/image" }
    it_should_behave_like "protected resource", "page.driver.delete(@uri)"

    context "when logged in" do
      before { basic_auth(@user) } 

      context "with uploaded image" do
        before { @resource.update_attributes(image: File.new(@image_path)) }

        scenario "remove the image" do
          page.driver.delete(@uri)
          page.status_code.should == 302
          @resource = Status.last
          @resource.image_url.should match /default/
        end
      end

      it_should_behave_like "a rescued 404 resource", "page.driver.delete(@uri)", "statuses", "/image"
    end
  end
end
