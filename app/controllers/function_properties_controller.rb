class FunctionPropertiesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource
  before_filter :find_connection, only: %w(show update destroy)
  before_filter :find_connected_resource, only: %w(show update destroy)
  before_filter :find_existing_connection, only: :create

  def show
  end

  def create
    @function_property = @function.function_properties.create!(json_body)
    @property = Property.where(created_from: current_user.uri, uri: @function_property.uri).first
    if @property
      render 'show', status: 201, location: @function_property.connection_uri and return
    else
      render_404 "notifications.connection.not_found", {uri: @function_property.uri} unless @property
    end
  end

  def destroy
    @function_property.destroy
    @property = Property.where(created_from: current_user.uri, uri: @function_property.uri).first
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
      render_404 "notifications.connection.not_found", {uri: params[:uri]}  unless @function_property
    end

    def find_connected_resource
      @property = Property.where(created_from: current_user.uri, uri: @function_property.uri).first
      render_404 "notifications.connection.not_found", {uri: @function_property.uri} unless @property
    end

    def find_existing_connection
      @function_property = @function.function_properties.where(uri: json_body[:uri]).first
      render_422 "notifications.connection.found", "The resource #{json_body[:uri]} is already connected" if @function_property
    end
end
