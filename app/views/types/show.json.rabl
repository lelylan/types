object TypeDecorator.decorate(@type)

attributes :uri, :id, :name, :created_at, :updated_at

node :properties do |type|
  properties = PropertyDecorator.decorate(Property.in(_id: type.property_ids))
  partial("properties/index", object: properties)
end

node :functions do |type|
  functions = FunctionDecorator.decorate(Function.in(_id: type.function_ids))
  partial("functions/index", object: functions)
end

node :statuses do |type|
  statuses = StatusDecorator.decorate(Status.in(_id: type.status_ids))
  partial("statuses/index", object: statuses)
end

