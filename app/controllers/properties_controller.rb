class PropertiesController < ApplicationController
  include Lelylan::Search::URI

  doorkeeper_for :create, :update, :destroy, scopes: [:write]

  before_filter :find_owned_resources,  except: %w(public show)
  before_filter :find_public_resources, only: %w(public show)
  before_filter :find_resource,         only: %w(show update destroy)
  before_filter :search_params,         only: %w(index public)
  before_filter :pagination,            only: %w(index public)

  def index
    @properties = @properties.limit(params[:per])
  end

  def public
    @properties = @properties.limit(params[:per])
    render 'index'
  end

  def show
  end

  def create
    @property = Property.new(params)
    @property.resource_owner_id = current_user.id
    if @property.save
      render 'show', status: 201, location: PropertyDecorator.decorate(@property).uri
    else
      render_422 'notifications.resource.not_valid', @property.errors
    end
  end

  def update
    if @property.update_attributes(params)
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
      @properties = Property.where(resource_owner_id: current_user.id)
    end

    def find_public_resources
      @properties = Property.all
    end

    def find_resource
      @property = @properties.find(params[:id])
    end

    def search_params
      @properties = @properties.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      params[:per] = Settings.pagination.per if params[:per] == 0 
      params[:per] = Settings.pagination.max_per if params[:per] > Settings.pagination.max_per
      @properties = @properties.gt(_id: find_id(params[:start])) if params[:start]
    end
end
