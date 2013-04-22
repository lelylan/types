class StatusSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :function, :properties, :created_at, :updated_at

  def uri
    StatusDecorator.decorate(object).uri
  end

  def function
    object.function_id ? { id: object.function_id, uri: object.decorate.function_uri } : nil
  end

  def properties
    object.properties.map do |property|
      property = StatusPropertyDecorator.decorate(property)
      { uri: property.uri, id: property.id, value: property.value, pending: property.pending }
    end
  end
end
