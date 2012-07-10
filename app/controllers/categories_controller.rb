class CategoriesController < ApplicationController
  include Lelylan::Search::URI

  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)
  before_filter :search_params, only: 'index'
  before_filter :pagination, only: 'index'


  def index
    @categories = @categories.limit(params[:per])
  end

  def show
  end

  def create
    body = JSON.parse(request.body.read)
    @category = Category.new(body)
    @category.created_from = current_user.uri
    if @category.save
      render 'show', status: 201, location: CategoryDecorator.decorate(@category).uri
    else
      render_422 "notifications.resource.not_valid", @category.errors
    end
  end

  def update
    body = JSON.parse(request.body.read)
    if @category.update_attributes(body)
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
      @categories = Category.where(created_from: current_user.uri)
    end

    def find_resource
      @category = @categories.find(params[:id])
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      @categories = @categories.gt(_id: find_id_from_uri(params[:start])) if params[:start]
    end

    def search_params
      @categories = @categories.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end 
end
