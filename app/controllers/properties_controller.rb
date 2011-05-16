class PropertiesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

  def index
    @properties =  @properties.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @property = Property.base(json_body, request, current_user)
    if @property.save
      render "show", status: 201, location: @property.uri
    else
      render_422 "notifications.document.not_valid", @property.errors
    end
  end

  def update
    if @property.update_attributes(json_body)
      render "show"
    else
      render_422 "notifications.document.not_valid", @property.errors
    end
  end

  def destroy
    @property.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @properties = Property.where(created_from: current_user.uri)
    end

    def find_resource
      @property = @properties.find(params[:id])
    end
end
