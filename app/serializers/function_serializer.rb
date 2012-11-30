class FunctionSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :properties, :created_at, :updated_at

  def uri
    FunctionDecorator.decorate(object).uri
  end

  def properties
    object.properties.map do |property|
      property = FunctionPropertyDecorator.decorate property
      { uri: property.uri, value: property.value }
    end
  end
end
