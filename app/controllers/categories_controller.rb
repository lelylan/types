class CategoriesController < ApplicationController
  def index
    render json: Type::CATEGORIES
  end
end
