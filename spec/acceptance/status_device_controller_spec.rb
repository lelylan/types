# TODO: refactoring

require 'spec_helper'

def add_default_status
  Factory.create(:default_status)
  type.type_statuses.create(uri: DEFAULT_STATUS_URI)
end

def add_matching_status
  type.type_statuses.create(uri: STATUS_URI)
  resource.status_properties.create(uri: PROPERTY_STATUS_URI, values: ["on"], pending: "false")
  resource.status_properties.create(uri: PROPERTY_INTENSITY_URI, values: ["40"], pending: "false")
end

describe StatusDeviceController do

  it { should route(:post, "statuses/device").to(action: "create", format: "json") }

  let(:resource_name) { "status" }
  let(:device) { Marshal.load(Marshal.dump(DEVICE_STRUCTURE)) }

  before(:each) { User.destroy_all }
  let(:current_user) { Factory.create(:user) }

  # -------
  # CREATE
  # -------

  describe "POST device's status" do
    let(:type)     { Factory.create(:type) }
    let(:action_name) { "create" }

    def do_action(options = {})
      options = device.merge(options)
      do_create(options)
    end

    before(:each) { Status.destroy_all }

    context "when logged in" do
      let(:resource) { Factory.create(:status, order: 1) }
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
        add_default_status
        add_matching_status
        do_action(id: resource.id.as_json)
      end

      it { should respond_with 302 }
      it_should_behave_like "a findable resource"

      context "with device properties matching a status" do
        it { assigns("status").uri.should == STATUS_URI }
        it { assigns("status").default.should == "false" }

        context "with one status value empty" do
          before(:each) do
            status_property = resource.status_properties.where(uri: PROPERTY_INTENSITY_URI).first
            status_property.values = []
            status_property.save!
            device[:device][:properties][1][:value] = "0"
            do_action(id: resource.id.as_json)
          end
          it { assigns("accepted_statuses").should have(2).item }
          it { assigns("status").default.should == "false" }
        end

        context "with one pending value empty" do
          before(:each) do
            status_property = resource.status_properties.where(uri: PROPERTY_INTENSITY_URI).first
            status_property.pending = ""
            status_property.save!
            device[:device][:properties][1][:pending] = "true"
            do_action(id: resource.id.as_json)
          end
          it { assigns("accepted_statuses").should have(2).item }
          it { assigns("status").default.should == "false" }
        end
      end

      context "without device properties matching a status" do
        context "with a different value" do
          before(:each) do
            device[:device][:properties][1][:value] = "0"
            do_action(id: resource.id.as_json)
          end
          it { assigns("accepted_statuses").should have(1).item }
          it { assigns("status").default.should == "true" }
        end

        context "with one different pending value" do
          before(:each) do
            device[:device][:properties][1][:pending] = "true"
            do_action(id: resource.id.as_json)
          end
          it { assigns("accepted_statuses").should have(1).item }
          it { assigns("status").default.should == "true" }
        end
      end

    end
  end

end
