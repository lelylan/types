class CategoriesController < ApplicationController
  doorkeeper_for :index, scopes: %w(types.read types resources.read resources).map(&:to_sym)
  doorkeeper_for :create, :update, :destroy, scopes: %w(types resources).map(&:to_sym)

  before_filter :find_owned_resources,  except: %w(public show)
  before_filter :find_public_resources, only: %w(public show)
  before_filter :find_resource,         only: %w(show update destroy)
  before_filter :search_params,         only: %w(index public)
  before_filter :pagination,            only: %w(index public)

  def index
    @categories = @categories.limit(params[:per])
  end

  def public
    @categories = @categories.limit(params[:per])
    render 'index'
  end

  def show
  end

  def create
    @category = Category.new(params)
    @category.resource_owner_id = current_user.id
    if @category.save!
      render 'show', status: 201, location: CategoryDecorator.decorate(@category).uri
    else
      render_422 'notifications.resource.not_valid', @category.errors
    end
  end

  def update
    if @category.update_attributes!(params)
      render 'show'
    else
      render_422 'notifications.resource.not_valid', @category.errors
    end
  end

  def destroy
    render 'show'
    @category.destroy
  end

  private

  def find_owned_resources
    @categories = Category.where(resource_owner_id: current_user.id)
  end

  def find_public_resources
    @categories = Category.all
  end

  def find_resource
    @category = @categories.find(params[:id])
  end

  def search_params
    @categories = @categories.where('name' => /.*#{params[:name]}.*/i) if params[:name]
  end

  def pagination
    params[:per] = (params[:per] || Settings.pagination.per).to_i
    params[:per] = Settings.pagination.per if params[:per] == 0 
    params[:per] = Settings.pagination.max_per if params[:per] > Settings.pagination.max_per
    @categories = @categories.gt(id: find_id(params[:start])) if params[:start]
  end
end
