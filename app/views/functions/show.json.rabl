object FunctionDecorator.decorate(@function)

node(:uri)        { |c| c.uri }
node(:id)         { |c| c.id }
node(:name)       { |c| c.name }

node(:properties) do |function|
  function.function_properties.map do |property|
    property = FunctionPropertyDecorator.decorate(property)
    { uri: property.uri, value: property.value }
  end
end

