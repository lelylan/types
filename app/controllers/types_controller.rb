class TypesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)
  before_filter :find_connections, only: %w(show destroy)

  def index
    @types = @types.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @type = Type.base(json_body, request, current_user)
    if @type.save
      create_default_status(@type)
      find_connections
      render 'show', status: 201, location: @type.uri
    else
      render_422 'notifications.document.not_valid', @type.errors
    end
  end

  def update
    if @type.update_attributes(json_body)
      find_connections
      render 'show'
    else
      render_422 'notifications.document.not_valid', @type.errors
    end
  end

  def destroy
    @type.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @types = Type.where(created_from: current_user.uri)
    end

    def find_resource
      @type = @types.find(params[:id])
    end

    def find_connections
      @properties = Property.any_in(uri: @type.properties)
      @functions = Function.any_in(uri: @type.functions)
    end

    def create_default_status(type)
      @status = Status.base({name: 'Default status'}, request, current_user)
      @status.default = true
      @status.save
      type.type_statuses.create(uri: @status.uri, order: Settings.statuses.default_order)
    end
end
