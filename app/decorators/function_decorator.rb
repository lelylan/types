class FunctionDecorator < ApplicationDecorator
  decorates :Function

  def uri
    h.function_path(model, default_options)
  end
end
