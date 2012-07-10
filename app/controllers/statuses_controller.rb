class StatusesController < ApplicationController
  include Lelylan::Search::URI

  before_filter :find_owned_resources, except: %w(public show)
  before_filter :find_all_resources, only: %w(public show)
  before_filter :find_resource, only: %w(show update destroy)
  before_filter :search_params, only: %w(index public)
  before_filter :pagination, only: %w(index public)


  def index
    @statuses = @statuses.limit(params[:per])
  end

  def public
    @statuses = @statuses.limit(params[:per])
    render 'index'
  end

  def show
  end

  def create
    body = JSON.parse(request.body.read)
    @status = Status.new(body)
    @status.created_from = current_user.uri
    if @status.save
      render 'show', status: 201, location: StatusDecorator.decorate(@status).uri
    else
      render_422 "notifications.resource.not_valid", @status.errors
    end
  end

  def update
    body = JSON.parse(request.body.read)
    if @status.update_attributes(body)
      render 'show'
    else
      render_422 'notifications.resource.not_valid', @status.errors
    end
  end

  def destroy
    render 'show'
    @status.destroy
  end



  private

    def find_owned_resources
      @statuses = Status.where(created_from: current_user.uri)
    end

    def find_all_resources
      @statuses = Status.all
    end

    def find_resource
      @status = @statuses.find(params[:id])
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      params[:per] = Settings.pagination.per if params[:per] == 0 or params[:per] > Settings.pagination.max_per
      @statuses = @statuses.gt(_id: find_id_from_uri(params[:start])) if params[:start]
    end

    def search_params
      @statuses = @statuses.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end 
end
