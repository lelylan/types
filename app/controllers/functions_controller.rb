class FunctionsController < ApplicationController
  include Lelylan::Search::URI

  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)
  before_filter :search_params, only: 'index'
  before_filter :pagination, only: 'index'


  def index
    @functions = @functions.limit(params[:per])
  end

  def show
  end

  def create
    body = JSON.parse(request.body.read)
    @function = Function.new(body)
    @function.created_from = current_user.uri
    if @function.save
      render 'show', status: 201, location: FunctionDecorator.decorate(@function).uri
    else
      render_422 "notifications.resource.not_valid", @function.errors
    end
  end

  def update
    body = JSON.parse(request.body.read)
    if @function.update_attributes(body)
      render 'show'
    else
      render_422 'notifications.resource.not_valid', @function.errors
    end
  end

  def destroy
    render 'show'
    @function.destroy
  end



  private

    def find_owned_resources
      @functions = Function.where(created_from: current_user.uri)
    end

    def find_resource
      @function = @functions.find(params[:id])
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      @functions = @functions.gt(_id: find_id_from_uri(params[:start])) if params[:start]
    end

    def search_params
      @functions = @functions.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end 
end
