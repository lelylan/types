require 'spec_helper'

describe StatusIconController do

  it { should route(:get, "/statuses/1/icon").to(:action => :show, :id => "1", :format => "png")}
  it { should route(:put, "/statuses/1/icon").to(:action => :update, :id => "1", :format => "png")}

  let(:resource_name) { "status" }
  let(:resource_model) { Status }
  let(:path) { Rails.root + 'spec/fixtures/media/square.png' }

  before(:each) { User.destroy_all }
  let(:current_user) { Factory.create(:user) }


  # -----
  # SHOW
  # -----

  describe "SHOW a status icon" do
    let(:resource) { Factory(resource_name) }
    let(:action_name) { "update_icon" }

    def do_action(options = {})
      attributes = { id: resource.id.as_json, format: "png" }
      attributes.merge!(options.symbolize_keys!)
      resource.icon = File.new(path)
      resource.save
      get :show, attributes
    end

    context "when logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
        do_action
      end
      it { should respond_with 302 }
      it_should_behave_like "a findable resource"

      it { assigns("icon").height.should == 128 }
      it { assigns("icon").width.should  == 128 }

      context "when resized" do
        context "with valid sizes" do
          before(:each) { do_action(size: "16x16") }
          it { assigns("icon").width.should  == 16 }
          it { assigns("icon").height.should == 16 }
        end

        context "with not valid sizes" do
          before(:each) { do_action(size: "pippo") }
          it { should respond_with 422 }
        end
      end
    end

    context "when not logged in" do
      before(:each) { do_action }
      it_should_behave_like "a not authenticated request"
    end
  end


  # -------
  # UPDATE
  # -------

  describe "UPDATE a status icon" do
    let(:resource) { Factory(resource_name) }
    let(:action_name) { "update" }

    def do_action(options = {})
      attributes = { id: resource.id.as_json, format: "json" }
      attributes.merge!(options.symbolize_keys!)
      put :update, attributes
    end

    context "when logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
        do_action(icon: File.new(path))
      end
      it { should respond_with 200}
      it_should_behave_like "a json resource"
      it_should_behave_like "a findable resource"
      it { assigns("status").icon.name.should match /square/ }
    end

    context "when not logged in" do
      before(:each) { do_action }
      it_should_behave_like "a not authenticated request"
    end
  end

end
