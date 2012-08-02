object StatusDecorator.decorate(@status)

attributes :uri, :id, :name, :pending

node(:properties) do |status|
  status.properties.map do |property|
    property = StatusPropertyDecorator.decorate(property)
    { 
      uri:       property.uri, 
      values:    property.values,
      min_range: property.min_range, 
      max_range: property.max_range
    }
  end
end

attributes :created_at, :updated_at
