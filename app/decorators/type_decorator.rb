class TypeDecorator < ApplicationDecorator
  decorates :Type

  def uri
    h.type_path(model, default_options)
  end
end
