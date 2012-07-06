object StatusDecorator.decorate(@status)

node(:uri)        { |c| c.uri }
node(:id)         { |c| c.id }
node(:name)       { |c| c.name }

node(:properties) do |status|
  status.status_properties.map do |property|
    property = StatusPropertyDecorator.decorate(property)
    { uri: property.uri, pending: property.pending, values: property.values }
  end
end

