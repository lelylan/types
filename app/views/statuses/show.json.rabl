object StatusDecorator.decorate(@status)

attributes :uri, :id, :name, :pending

node(:properties) do |status|
  status.properties.map do |property|
    property = StatusPropertyDecorator.decorate(property)
    result = { uri: property.uri }
    result[:values] = property.values 
    result[:range] = (property.max or property.min) ? {min: property.min, max: property.max} : nil
    result
  end
end

attributes :created_at, :updated_at
