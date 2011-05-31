class FunctionPropertiesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :find_connection, only: %w(show update destroy)
  before_filter :find_connected_resource, only: %w(show update destroy)
  before_filter :find_existing_connection, only: 'create'

  def show
  end

  def create
    @property = find_property_from_connection(json_body[:uri])
    if @property
      @function_property = @function.function_properties.create!(json_body)
      render 'show', status: 201, location: @function_property.connection_uri and return
    else
      render_404 'notifications.connection.not_found', {uri: json_body[:uri] }
    end
  end

  def update
    json_body.delete(:uri) # this attribute can not be updated
    @function_property.update_attributes!(json_body)
    render 'show'
  end

  def destroy
    @function_property.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @functions = Function.where(created_from: current_user.uri)
    end

    def find_resource
      @function = @functions.find(params[:id])
    end

    def find_connection
      @function_property = @function.function_properties.where(uri: params[:uri]).first
      render_404 'notifications.connection.not_found', {uri: params[:uri]}  unless @function_property
    end

    def find_connected_resource
      @preoperty = find_property_from_connection(@function_property.uri)
      render_404 'notifications.connection.not_found', {uri: @function_property.uri} unless @property
    end

    def find_existing_connection
      @function_property = @function.function_properties.where(uri: json_body[:uri]).first
      render_422 'notifications.connection.found', json_body[:uri] if @function_property
    end

      # Returns the property only the authenticated user is the owner
      def find_property_from_connection(property_uri)
        @property = Property.where(created_from: current_user.uri, uri: property_uri).first
      end
end
