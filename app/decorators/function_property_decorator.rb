class FunctionPropertyDecorator < ApplicationDecorator
  decorates :FunctionProperty

  def uri
    h.property_path(model.property_id, default_options)
  end
end
