class TypesController < ApplicationController

  doorkeeper_for :index, scopes: Settings.scopes.read.map(&:to_sym)
  doorkeeper_for :create, :update, :destroy, scopes: Settings.scopes.write.map(&:to_sym)

  before_filter :find_owned_resources,  except: %w(public show)
  before_filter :find_public_resources, only: %w(public show)
  before_filter :find_resource,         only: %w(show update destroy)
  before_filter :search_params,         only: %w(index public)
  before_filter :pagination,            only: %w(index public)


  def index
    @types = @types.limit(params[:per])
    render json: @types, each_serializer: TypeShortSerializer
  end

  def public
    @types = @types.limit(params[:per])
    render json: @types, each_serializer: TypeShortSerializer
  end

  def show
    render json: @type if stale?(@type)
  end

  def create
    @type = Type.new(params)
    @type.resource_owner_id = current_user.id
    if @type.save
      render json: @type, status: 201, location: TypeDecorator.decorate(@type).uri
    else
      render_422 'notifications.resource.not_valid', @type.errors
    end
  end

  def update
    if @type.update_attributes(params)
      render json: @type
    else
      render_422 'notifications.resource.not_valid', @type.errors
    end
  end

  def destroy
    render json: @type
    @type.destroy
  end


  private

  def find_owned_resources
    @types = Type.where(resource_owner_id: current_user.id)
  end

  def find_public_resources
    @types = Type.all
  end

  def find_resource
    @type = @types.find(params[:id])
  end

  def search_params
    @types = @types.where('name' => /.*#{params[:name]}.*/i) if params[:name]
  end

  def pagination
    params[:per] = (params[:per] || Settings.pagination.per).to_i
    params[:per] = Settings.pagination.per if params[:per] == 0
    params[:per] = Settings.pagination.max_per if params[:per] > Settings.pagination.max_per
    @types = @types.gt(_id: find_id(params[:start])) if params[:start]
  end
end
