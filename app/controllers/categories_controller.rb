class CategoriesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

  def index
    @categories =  @categories.page(params[:page]).per(params[:per])
  end

  def show
  end

  def create
    @category = Category.base(json_body, request, current_user)
    if @category.save
      render "show", status: 201, location: @category.uri
    else
      render_422 "notifications.document.not_valid", @category.errors
    end
  end

  def update
    if @category.update_attributes(json_body)
      render "show"
    else
      render_422 "notifications.document.not_valid", @category.errors
    end
  end

  def destroy
    @category.destroy
    render 'show'
  end


  private

    def find_owned_resources
      @categories = Category.where(created_from: current_user.uri)
    end

    def find_resource
      @category = @categories.find(params[:id])
    end
end
