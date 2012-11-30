class StatusSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :pending, :properties, :created_at, :updated_at

  def uri
    StatusDecorator.decorate(object).uri
  end

  def properties
    object.properties.map do |property|
      property = StatusPropertyDecorator.decorate(property)
      result = { uri: property.uri, values: property.values }
      result[:range] = (property.max or property.min) ? {min: property.min, max: property.max} : nil
      result
    end
  end
end
