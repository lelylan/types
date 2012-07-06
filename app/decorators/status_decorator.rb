class StatusDecorator < ApplicationDecorator
  decorates :Status

  def uri
    h.status_path(model, default_options)
  end
end
