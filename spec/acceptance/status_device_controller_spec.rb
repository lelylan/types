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


  # POST /statuses/device
  context ".create" do
    before { @uri = "/statuses/device" }

    #it_should_behave_like "protected resource", "page.driver.post(@uri)"

    context "when logged in" do
      before { basic_auth(@user) }
      let(:params) {{ device: JSON.parse(Settings.device_json) }}

      scenario "create resource" do
        page.driver.post(@uri, params.to_json)
        #save_and_open_page
      end

      #context "with not valid params" do
        #scenario "get a not valid notification" do
          #page.driver.post(@uri, {}.to_json)
          #should_have_a_not_valid_resource
          #should_have_valid_json(page.body)
        #end
      #end

    end
  end
end
