object TypeDecorator.decorate(@type)

attributes :uri, :id, :name, :public

node(:properties) do |type|
  collection Property.in(_id: type.property_ids)
  extends 'properties/index'
end

