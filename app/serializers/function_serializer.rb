class FunctionSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :properties, :created_at, :updated_at

  def uri
    FunctionDecorator.decorate(object).uri
  end

  def properties
    object.properties.map do |property|
      property = FunctionPropertyDecorator.decorate property
      { uri: property.uri, expected: property.expected }
    end
  end
end
