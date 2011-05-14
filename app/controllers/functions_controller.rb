class FunctionsController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

  def index
    @functions = @functions.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @function = Function.base(json_body, request, current_user)
    if @function.save
      render 'show', status: 201, location: @function.uri
    else
      render_422 'notifications.document.not_valid', @function.errors
    end
  end

  def update
    if @function.update_attributes(@body)
      render 'show'
    else
      render_422 'notifications.document.not_valid', @function.errors
    end
  end

  def destroy
    @function.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @functions = Function.where(created_from: current_user.uri)
    end

    def find_resource
      @function = @functions.find(params[:id])
    end
end
