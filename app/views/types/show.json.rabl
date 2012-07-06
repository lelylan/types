object TypeDecorator.decorate(@type)

attributes :uri, :id, :name, :public

node :properties do |type|
  partial("properties/index", object: Property.in(_id: type.property_ids) )
end

node :functions do |type|
  partial("functions/index", object: Function.in(_id: type.function_ids) )
end

node :statuses do |type|
  partial("statuses/index", object: Status.in(_id: type.status_ids) )
end

attributes :created_at, :updated_at
