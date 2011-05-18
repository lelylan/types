class TypesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_public_resources
  before_filter :find_public_resource, only: :show
  before_filter :find_owned_resources
  before_filter :find_owned_resource, only: %w(show update destroy)

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
    
    def find_public_resources
      if accessing_public_resource?
        @resources = Type.where(public: true)
      end
    end

    def find_public_resource
      if accessing_public_resource?
        @resource = @resources.where(_id: params[:id]).first
        render_401 if @resource.nil?
      end
    end
    
    def find_owned_resources
      if not accessing_public_resource?
        @resources = Type.where(created_from: current_user.uri)
      end
    end

    def find_owned_resource
      if not accessing_public_resource?
        @resource = @resources.find(params[:id])
      end
    end

    def default_status_for(type)
      @status = Status.base_default(type, {name: 'Default status'}, request, current_user)
    end
end
