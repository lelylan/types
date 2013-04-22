class FunctionSerializer < ApplicationSerializer
  cached true

  attributes :id, :uri, :name, :properties, :created_at, :updated_at

  def uri
    FunctionDecorator.decorate(object).uri
  end

  def properties
    object.properties.map do |property|
      property = FunctionPropertyDecorator.decorate property
      { id: property.property_id, uri: property.uri, value: property.value, pending: property.pending }
    end
  end
end
