object StatusDecorator.decorate(@status)

attributes :uri, :id, :name

node(:properties) do |status|
  status.properties.map do |property|
    property = StatusPropertyDecorator.decorate(property)
    { 
      uri: property.uri, 
      pending: property.pending, 
      values: property.values,
      range: { start: property.range_start, end: property.range_end } 
    }
  end
end

