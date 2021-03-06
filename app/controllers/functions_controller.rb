class FunctionsController < ApplicationController

  doorkeeper_for :index, scopes: Settings.scopes.read.map(&:to_sym)
  doorkeeper_for :create, :update, :destroy, scopes: Settings.scopes.write.map(&:to_sym)

  before_filter :find_owned_resources,  except: %w(public show)
  before_filter :find_public_resources, only: %w(public show)
  before_filter :find_resource,         only: %w(show update destroy)
  before_filter :search_params,         only: %w(index public)
  before_filter :pagination,            only: %w(index public)


  def index
    @functions = @functions.desc(:id).limit(params[:per])
    render json: @functions
  end

  def public
    @functions = @functions.desc(:id).limit(params[:per])
    render json: @functions
  end

  def show
    render json: @function if stale?(@function)
  end

  def create
    @function = Function.new(params)
    @function.resource_owner_id = current_user.id
    if @function.save
      render json: @function, status: 201, location: FunctionDecorator.decorate(@function).uri
    else
      render_422 'notifications.resource.not_valid', @function.errors
    end
  end

  def update
    if @function.update_attributes(params)
      render json: @function
    else
      render_422 'notifications.resource.not_valid', @function.errors
    end
  end

  def destroy
    render json: @function
    @function.destroy
  end


  private

  def find_owned_resources
    @functions = Function.where(resource_owner_id: current_user.id)
  end

  def find_public_resources
    @functions = Function.all
  end

  def find_resource
    @function = @functions.find(params[:id])
  end

  def search_params
    @functions = @functions.where('name' => /.*#{params[:name]}.*/i) if params[:name]
  end

  def pagination
    params[:per] = (params[:per] || Settings.pagination.per).to_i
    params[:per] = Settings.pagination.per if params[:per] == 0
    params[:per] = Settings.pagination.max_per if params[:per] > Settings.pagination.max_per
    @functions = @functions.gt(id: find_id(params[:start])) if params[:start]
  end
end
