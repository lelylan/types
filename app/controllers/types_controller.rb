class TypesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_public_resource
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

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

    def find_public_resource
      @type = Type.where(_id: params[:id], public: true).first
    end

    def find_owned_resources
      @types = Type.where(created_from: current_user.uri)
    end

    def find_resource
      @type = @types.where(_id: params[:id]).first
      unless @type
        @type = Type.where(_id: params[:id], public: true).first
        unless @type
          raise Mongoid::Errors::DocumentNotFound.new(Type, {})
        end
      end
    end

    def default_status_for(type)
      @status = Status.base_default(type, {name: 'Default status'}, request, current_user)
    end
end
