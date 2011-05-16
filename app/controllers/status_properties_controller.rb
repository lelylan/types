class StatusPropertiesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :find_connection, only: %w(show update destroy)
  before_filter :find_connected_resource, only: %w(show update destroy)
  before_filter :find_existing_connection, only: :create


  def show
  end

  def create
    @status_property = @status.status_properties.create!(json_body)
    # TODO: find the way to reuse the find_connection status!
    @property = find_property_from_connection(@status_property)
    if @property
      render 'show', status: 201, location: @status_property.connection_uri and return
    else
      render_404 'notifications.connection.not_found', {uri: @status_property.uri}
    end
  end

  def destroy
    @status_property.destroy
    @property = find_property_from_connection(@status_property)
    render 'show'
  end


  private

    def find_owned_resources
      @statuses = Status.where(created_from: current_user.uri)
    end

    def find_resource
      @status = @statuses.find(params[:id])
    end

    def find_connection
      @status_property = @status.status_properties.where(uri: params[:uri]).first
      render_404 'notifications.connection.not_found', params[:uri] unless @status_property
    end

    def find_connected_resource
      @preoperty = find_property_from_connection(@status_property)
      render_404 'notifications.connection.not_found', {uri: @status_property.uri} unless @property
    end

    def find_existing_connection
      @status_property = @status.status_properties.where(uri: json_body[:uri]).first
      render_422 'notifications.connection.found', 'The resource #{json_body[:uri]} is already connected' if @status_property
    end
    
    # Helper methods
    def find_property_from_connection(status_property)
      @property = Property.where(created_from: current_user.uri, uri: status_property.uri).first
    end
end
