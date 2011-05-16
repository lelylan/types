class StatusesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

  def index
    @statuses = @statuses.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @status = Status.base(json_body, request, current_user)
    if @status.save
      render 'show', status: 201, location: @status.uri
    else
      render_422 'notifications.document.not_valid', @status.errors
    end
  end

  def update
    if @status.update_attributes(@body)
      render 'show'
    else
      render_422 'notifications.document.not_valid', @status.errors
    end
  end

  def destroy
    if @status.default?
      render_422 'notifications.document.not_deletable',  {uri: @status.uri}
    else
      @status.destroy
      render 'show'
    end
  end


  private

    def find_owned_resources
      @statuses = Status.where(created_from: current_user.uri)
    end

    def find_resource
      @status = @statuses.find(params[:id])
    end

end
