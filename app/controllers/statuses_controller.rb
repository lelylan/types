class StatusesController < ApplicationController
  doorkeeper_for :index, scopes: Settings.scopes.read.map(&:to_sym)
  doorkeeper_for :create, :update, :destroy, scopes: Settings.scopes.write.map(&:to_sym)

  before_filter :find_owned_resources,  except: %w(public show)
  before_filter :find_public_resources, only: %w(public show)
  before_filter :find_resource,         only: %w(show update destroy)
  before_filter :search_params,         only: %w(index public)
  before_filter :pagination,            only: %w(index public)

  def index
    @statuses = @statuses.limit(params[:per])
    render json: @statuses
  end

  def public
    @statuses = @statuses.limit(params[:per])
    render json: @statuses
  end

  def show
    render json: @status
  end

  def create
    @status = Status.new(params)
    @status.resource_owner_id = current_user.id
    if @status.save!
      render json: @status, status: 201, location: StatusDecorator.decorate(@status).uri
    else
      render_422 'notifications.resource.not_valid', @status.errors
    end
  end

  def update
    if @status.update_attributes!(params)
      render json: @status
    else
      render_422 'notifications.resource.not_valid', @status.errors
    end
  end

  def destroy
    render json: @status
    @status.destroy
  end



  private

    def find_owned_resources
      @statuses = Status.where(resource_owner_id: current_user.id)
    end

    def find_public_resources
      @statuses = Status.all
    end

    def find_resource
      @status = @statuses.find(params[:id])
    end

    def search_params
      @statuses = @statuses.where('name' => /.*#{params[:name]}.*/i) if params[:name]
    end

    def pagination
      params[:per] = (params[:per] || Settings.pagination.per).to_i
      params[:per] = Settings.pagination.per if params[:per] == 0
      params[:per] = Settings.pagination.max_per if params[:per] > Settings.pagination.max_per
      @statuses = @statuses.gt(_id: find_id(params[:start])) if params[:start]
    end
end
