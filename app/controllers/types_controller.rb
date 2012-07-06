class TypesController < ApplicationController
  include Lelylan::Search::URI

  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)
  before_filter :search_params, only: 'index'
  before_filter :pagination, only: 'index'


  def index
    @types = @types.limit(params[:per])
  end

  def show
  end

  def create
    body = JSON.parse(request.body.read)
    @type = Type.new(body)
    @type.created_from = current_user.uri
    if @type.save
      render 'show', status: 201, location: TypeDecorator.decorate(@type).uri
    else
      render_422 "notifications.resource.not_valid", @type.errors
    end
  end

  def update
    body = JSON.parse(request.body.read)
    if @type.update_attributes(body)
      render 'show'
    else
      render_422 'notifications.resource.not_valid', @type.errors
    end
  end

  def destroy
    render 'show'
    @type.destroy
  end



  private

    def find_owned_resources
      @types = Type.where(created_from: current_user.uri)
    end

    def find_resource
      @type = @types.find(params[:id])
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      @types = @types.gt(_id: find_id_from_uri(params[:start])) if params[:start]
    end

    def search_params
      @types = @types.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end 
end
