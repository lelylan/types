class TypesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_public_or_owned_resources, only: 'index'
  before_filter :find_public_or_owned_resource, only: 'show'
  before_filter :find_owned_resource, only: %w(update destroy)
  before_filter :filter_params, only: 'index'

  def index
    @types = @types.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @type = Type.base(json_body, request, current_user)
    default_status_for(@type)
    if @type.save
      render 'show', status: 201, location: @type.uri
    else
      render_422 'notifications.document.not_valid', @type.errors
    end
  end

  def update
    if @type.update_attributes(json_body)
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

    def find_public_or_owned_resources
      if params[:public] == 'true'
        @types = Type.where(public: true)
      else
        @types = Type.where(created_from: current_user.uri)
      end
    end

    def find_public_or_owned_resource
      @type = Type.where(_id: params[:id]).first
      check_for_public_or_owned_resource(@type)
    end

    def find_owned_resource
      @type = Type.where(created_from: current_user.uri).find(params[:id])
    end

    def default_status_for(type)
      @status = Status.base_default(type, {name: 'Default status'}, request, current_user)
    end

    def filter_params
      pp params
      @types.where('name' => /^#{params[:name]}/) if params[:name]
      @types.any_in(categories: params[:category]) if params[:category]
    end
end
