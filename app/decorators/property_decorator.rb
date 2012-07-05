class PropertyDecorator < ApplicationDecorator
  decorates :Property

  def uri
    h.property_path(model, default_options)
  end
end
