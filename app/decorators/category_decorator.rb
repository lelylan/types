class CategoryDecorator < ApplicationDecorator
  decorates :Category

  def uri
    h.category_path(model, default_options)
  end
end
