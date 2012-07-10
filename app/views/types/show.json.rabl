object TypeDecorator.decorate(@type)

attributes :uri, :id, :name, :public

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

node :categories do |type|
  categories = CategoryDecorator.decorate(Category.in(_id: type.category_ids))
  partial("categories/index", object: categories)
end

attributes :created_at, :updated_at
