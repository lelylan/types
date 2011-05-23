class CategoriesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_public_resources, only: 'public'
  before_filter :find_owned_resources
  before_filter :find_resource, only: %w(show update destroy)

  def index
    @categories =  @categories.page(params[:page]).per(params[:per])
  end

    def public
      @categories =  @categories.page(params[:page]).per(params[:per])
      render '/categories/index'
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
    
    def find_public_resources
      if accessing_public_resource?
        @categories = Category.where(public: true)
      end
    end

    def find_public_resource
      if accessing_public_resource?
        @category = @categories.where(_id: params[:id]).first
        render_401 if @category.nil?
      end
    end

    def find_owned_resources
      if not accessing_public_resource?
        @categories = Category.where(created_from: current_user.uri)
      end
    end

    def find_resource
      if not accessing_public_resource?
        @category = @categories.find(params[:id])
      end
    end
end
