class TypeDecorator < ApplicationDecorator
  decorates :Type

  def uri
    h.type_path(model, default_options)
  end

  def resource_owner_uri
    "#{h.request.protocol}#{people_host}/people/#{model.resource_owner_id}"
  end
end
