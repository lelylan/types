class TypesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

  def index
    @resources = @resources.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @resource = Type.base(json_body, request, current_user)
    default_status_for(@resource)
    if @resource.save
      render 'show', status: 201, location: @resource.uri
    else
      render_422 'notifications.document.not_valid', @resource.errors
    end
  end

  def update
    if @resource.update_attributes(json_body)
      render 'show'
    else
      render_422 'notifications.document.not_valid', @resource.errors
    end
  end

  def destroy
    @resource.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @resources = Type.where(created_from: current_user.uri) unless @resources
    end

    def find_resource
      @resource = @resources.find(params[:id]) unless @resource
    end

    def default_status_for(type)
      @status = Status.base_default(type, {name: 'Default status'}, request, current_user)
    end
end
