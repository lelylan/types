class PropertiesController < ApplicationController
  include Lelylan::Search::URI

  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)
  before_filter :search_params, only: 'index'
  before_filter :pagination, only: 'index'


  def index
    @properties = @properties.limit(params[:per])
  end

  def show
  end

  def create
    body = JSON.parse(request.body.read)
    @property = Property.new(body)
    @property.created_from = current_user.uri
    if @property.save
      render 'show', status: 201, location: PropertyDecorator.decorate(@property).uri
    else
      render_422 "notifications.resource.not_valid", @property.errors
    end
  end

  def update
    body = JSON.parse(request.body.read)
    if @property.update_attributes(body)
      render 'show'
    else
      render_422 'notifications.resource.not_valid', @property.errors
    end
  end

  def destroy
    render 'show'
    @property.destroy
  end



  private

    def find_owned_resources
      @properties = Property.where(created_from: current_user.uri)
    end

    def find_resource
      @property = @properties.find(params[:id])
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      @properties = @properties.gt(_id: find_id_from_uri(params[:start])) if params[:start]
    end

    def search_params
      @properties = @properties.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end 
end
