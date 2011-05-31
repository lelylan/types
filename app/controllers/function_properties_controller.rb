class FunctionPropertiesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :find_connection, only: %w(show update destroy)
  before_filter :find_connected_resource, only: %w(show update destroy)
  before_filter :find_existing_connection, only: :create

  def show
  end

  # TODO: find the way to reuse the find_connection function!
  def create
    @function_property = @function.function_properties.create!(json_body)
    @property = find_property_from_connection(@function_property)
    if @property
      render 'show', status: 201, location: @function_property.connection_uri and return
    else
      render_404 'notifications.connection.not_found', {uri: @function_property.uri}
    end
  end

  def destroy
    @function_property.destroy
    @property = find_property_from_connection(@function_property)
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
      @preoperty = find_property_from_connection(@function_property)
      render_404 'notifications.connection.not_found', {uri: @function_property.uri} unless @property
    end

    def find_existing_connection
      @function_property = @function.function_properties.where(uri: json_body[:uri]).first
      render_422 'notifications.connection.found', json_body[:uri] if @function_property
    end

    # Returns the property if I'm the owner
    def find_property_from_connection(function_property)
      @property = Property.where(created_from: current_user.uri, uri: function_property.uri).first
    end
end
