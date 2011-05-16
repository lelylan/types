require 'spec_helper'

describe StatusPropertiesController do

  it { should route(:get, "statuses/1/properties").to(action: "show", format: "json", id: "1") }
  it { should route(:post, "statuses/1/properties").to(action: "create", format: "json", id: "1") }
  it { should route(:put, "statuses/1/properties").to(action: "update", format: "json", id: "1") }
  it { should route(:delete, "statuses/1/properties").to(action: "destroy", format: "json", id: "1") }

  let(:parent_resource_name)    { "status" }
  let(:connected_resource_name) { "property" }
  let(:resource_name)           { "status_property" }
  let(:parent_resource)         { Factory.create(:status) }
  let(:uri)                    { PROPERTY_INTENSITY_URI }

  before(:each) { User.destroy_all }
  let(:current_user) { Factory.create(:user) }

  # -----
  # SHOW
  # -----

  describe "GET a status property" do
    let(:action_name) { "show" }
    let(:resource) { parent_resource.send(resource_name.pluralize).create(uri: uri) }

    def do_action(options = {})
      options = { id: parent_resource.id.as_json, uri: uri }.merge!(options)
      do_get(options)
    end

    context "when logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
        do_action
      end

      it { should respond_with 200 }
      it_should_behave_like "a json resource"
      it_should_behave_like "a connected resource"
    end

    context "when not logged in" do
      before(:each) { do_action }
      it_should_handle "a not authenticated request"
    end
  end

  # -------
  # CREATE
  # -------

  describe "CREATE a status property" do
    let(:action_name) { "create" }

    def do_action(options = {})
      options = { id: parent_resource.id.as_json, uri: uri }.merge!(options)
      do_create(options)
    end

    context "when logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
      end

      context "when a json resource" do
        before(:each) do
          do_action
        end
        it { should respond_with 201}
        it_should_behave_like "a json resource"
      end
      it_should_behave_like "a connectable resource"
      it_should_handle "a list of values creation"

      context "with default status" do
        before(:each) do
          parent_resource.default = "true"
          parent_resource.save
          do_action
        end
        it "shoudl not create connections" do
          should respond_with 422
        end
      end

    end

    context "when not logged in" do
      before(:each) { do_action }
      it_should_handle "a not authenticated request"
    end
  end

  # -------
  # UPDATE
  # -------

  describe "UPDATE a status property" do
    let(:action_name) { "update" }
    let(:resource) { parent_resource.send(resource_name.pluralize).create(uri: uri) }

    def do_action(options = {})
      options = { id: parent_resource.id.as_json, uri: uri }.merge!(options)
      do_update_connection(options)
    end

    context "when logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
      end

      context "when a json resource" do
        before(:each) { do_action }
        it { should respond_with 200 }
        it_should_behave_like "a json resource"
      end
      it_should_behave_like "an updatable connected resource"
      it_should_handle "a list of values update"

      context "when update a not valid connected resource" do
        before(:each) do
          parent_resource.send(resource_name.pluralize).create(uri: uri)
          do_action(pending: "not_boolean")
        end
        it { should respond_with 422 }
      end
    end

    context "when not logged in" do
      before(:each) { do_action }
      it_should_handle "a not authenticated request"
    end
  end

  # -------
  # DELETE
  # -------

  describe "DELETE a status property" do
    let(:action_name) { "destroy" }

    def do_action(options = {})
      options = { id: parent_resource.id.as_json, uri: uri }.merge!(options)
      do_delete_connection(options)
    end

    context "when logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(current_user)
        controller.stub!(:authenticate).and_return(true)
        parent_resource.send(resource_name.pluralize).create(uri: uri)
      end

      context "when a json resource" do
        before(:each) { do_action }
        it { should respond_with 204}
        it_should_behave_like "a json resource"
      end
      it_should_behave_like "a disconnectable resource"
    end

    context "when not logged in" do
      before(:each) { do_action }
      it_should_handle "a not authenticated request"
    end
  end

end
