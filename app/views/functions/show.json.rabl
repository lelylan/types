object FunctionDecorator.decorate(@function)

attributes :uri, :id, :name

node(:properties) do |function|
  function.function_properties.map do |property|
    property = FunctionPropertyDecorator.decorate(property)
    { uri: property.uri, value: property.value }
  end
end

