class StatusPropertiesController < ApplicationController

  before_filter :json_body, only: ["create", "update"]
  before_filter :find_resource
  before_filter :find_connection_resource, only: ["show", "update", "destroy"]
  before_filter :find_existing_connection_resource, only: ["create"]
  before_filter :find_default, only: ["create"]


  def show
    render "show", status: 200 and return
  end

  def create
    @status_property = StatusProperty.new(@body)
    if @status_property.valid?
      @status.status_properties << @status_property
      @status.save
      render "show", status: 201, location: @status_property.connection_uri and return
    else
      render_422 "notifications.document.not_valid", @status_property.errors
    end
  end

  def update
    if @status_property.update_attributes(@body)
      render "show", status: 200, location: @status_property.connection_uri and return
    else
      render_422 "notifications.document.not_valid", @status_property.errors
    end
  end

  def destroy
    @status_property.destroy
    head 204 and return
  end



  private

    def find_resource
      @status = Status.owned_by(current_user).id(params[:id]).first
      render_404 "notifications.document.not_found", params[:id] unless @status
    end

    def find_connection_resource
      @status_property = @status.status_properties.where(uri: params[:uri]).first
      render_404 "notifications.connection.not_found", params[:uri] unless @status_property
    end

    def find_existing_connection_resource
      @status_property = @status.status_properties.where(uri: @body[:uri]).first
      render_422 "notifications.connection.found", { "uri" => @body[:uri] } if @status_property
    end

    def find_default
      if @status.default?
        render_422 "notifications.document.not_updatable",  { "uri" => @status.uri }
      end
    end

end
