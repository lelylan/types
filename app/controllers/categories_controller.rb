class CategoriesController < ApplicationController
  def index
    render json: Settings.categories
  end
end
