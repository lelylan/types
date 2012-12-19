class StatusSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :properties, :created_at, :updated_at

  def uri
    StatusDecorator.decorate(object).uri
  end

  def properties
    object.properties.map do |property|
      property = StatusPropertyDecorator.decorate(property)
      { uri: property.uri, id: property.id, matches: property.matches, pending: property.pending }
    end
  end
end
