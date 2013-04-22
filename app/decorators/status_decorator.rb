class StatusDecorator < ApplicationDecorator
  decorates :Status

  def uri
    h.status_path(model, default_options)
  end

  def function_uri
    "#{h.request.protocol}#{types_host}/functions/#{model.function_id}"
  end
end
