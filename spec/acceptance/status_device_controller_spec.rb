require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "StatusDeviceController" do
  before { host! "http://" + host }
  before { @user = Factory(:user) }
  before { Status.destroy_all }

  before { @resource = Factory(:type) }
  before { @not_owned_resource = Factory(:not_owned_type) }
  before { @is_setting_intensity = Factory(:is_setting_intensity) }
  before { @is_setting_max = Factory(:is_setting_max) }
  before { @has_set_intensity = Factory(:has_set_intensity) }
  before { @has_set_max = Factory(:has_set_max) }
  before { @default = Factory(:status) }


  # PUT /statuses/device
  context ".update" do
    before { @uri = "/statuses/device" }

    #it_should_behave_like "protected resource", "page.driver.put(@uri)"

    context "when logged in" do
      before { basic_auth(@user) }
      let(:params) {{ device: HashWithIndifferentAccess.new(JSON.parse(Settings.device_json)) }}

      scenario "create resource" do
        page.driver.put(@uri, params.to_json)
        page.status_code.should == 200
        page.should have_content Settings.statuses.is_setting_intensity.uri
        should_have_valid_json(page.body)
      end

      context "with pending to false" do
        before { params[:device][:properties][1][:pending] = false }
        scenario "should have 'has set intensity' status" do
          page.driver.put(@uri, params.to_json)
          page.status_code.should == 200
          save_and_open_page
          page.should have_content Settings.statuses.has_set_intensity.uri
        end
      end

      context "with intensity to 10.0" do
        before { params[:device][:properties][1][:value] = '10.0' }
        scenario "should have 'setting max' status" do
          page.driver.put(@uri, params.to_json)
          page.status_code.should == 200
          page.should have_content Settings.statuses.is_setting_max.uri
          should_have_valid_json(page.body)
        end

        context "with pending to false" do
          before { params[:device][:properties][1][:pending] = false }
          scenario "should have 'has set max' status" do
            page.driver.put(@uri, params.to_json)
            page.status_code.should == 200
            page.should have_content Settings.statuses.has_set_max.uri
            should_have_valid_json(page.body)
          end
        end
      end

      context "with values not found on statuses" do
        before { params[:device][:properties][1][:value] = 'not_existing' }
        scenario "should have default status" do
          page.driver.put(@uri, params.to_json)
          page.status_code.should == 200
          page.should have_content Settings.statuses.default.uri
          should_have_valid_json(page.body)
        end
      end

      context "with not valid params" do
        scenario "get a not valid notification" do
          page.driver.put(@uri, {}.to_json)
          should_have_a_not_valid_resource
          should_have_valid_json(page.body)
        end
      end
    end
  end
end
