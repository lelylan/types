class StatusPropertiesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :find_default, only: %w(create destroy)
  before_filter :find_connection, only: %w(show update destroy)
  before_filter :find_connected_resource, only: %w(show update destroy)
  before_filter :find_existing_connection, only: 'create'


  def show
  end

  def create
    @property = find_property_from_connection(json_body[:uri])
    if @property
      @status_property = @status.status_properties.create!(json_body)
      render 'show', status: 201, location: @status_property.connection_uri and return
    else
      render_404 'notifications.connection.not_found', {uri: json_body[:uri]}
    end
  end

  def update
    json_body.delete(:uri) # this attribute can not be updated
    @status_property.update_attributes!(json_body)
    render 'show'
  end

  def destroy
    @status_property.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @statuses = Status.where(created_from: current_user.uri)
    end

    def find_resource
      @status = @statuses.find(params[:id])
    end

    def find_default
      render_422 'notifications.document.protected', "The default status can not be updated or deleted" if @status.default?
    end

    def find_connection
      @status_property = @status.status_properties.where(uri: params[:uri]).first
      render_404 'notifications.connection.not_found', params[:uri] unless @status_property
    end

    def find_connected_resource
      @preoperty = find_property_from_connection(@status_property.uri)
      render_404 'notifications.connection.not_found', {uri: @status_property.uri} unless @property
    end

    def find_existing_connection
      @status_property = @status.status_properties.where(uri: json_body[:uri]).first
      render_422 'notifications.connection.found', json_body[:uri] if @status_property
    end
    

      # Returns the property only the authenticated user is the owner
      def find_property_from_connection(property_uri)
        @property = Property.where(created_from: current_user.uri, uri: property_uri).first
      end
end
