module HelpersViewMethods
  def has_type(type, json = nil)
    json.uri.should  == type.uri
    json.id.should   == type.id.as_json
    json.name.should == type.name

    properties = Property.in(_id: type.property_ids)
    json.properties.each_with_index do |json_property, i|
      has_property PropertyDecorator.decorate(properties[i]), json_property
    end

    functions = Function.in(_id: type.function_ids)
    json.functions.each_with_index do |json_function, i|
      has_function FunctionDecorator.decorate(functions[i]), json_function
    end

    statuses = Status.in(_id: type.status_ids)
    json.statuses.each_with_index do |json_status, i|
      has_status StatusDecorator.decorate(statuses[i]), json_status
    end

    categories = Category.in(_id: type.category_ids)
    json.categories.each_with_index do |json_category, i|
      has_category CategoryDecorator.decorate(categories[i]), json_category
    end
  end
end

RSpec.configuration.include HelpersViewMethods
