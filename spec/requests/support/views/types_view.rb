module TypesViewMethods

  def should_have_owned_type(type)
    type = TypeDecorator.decorate(type)
    json = JSON.parse(page.source)
    should_contain_type(type)
    should_not_have_not_owned_types
  end

  def should_contain_type(type)
    type = TypeDecorator.decorate(type)
    json = JSON.parse(page.source).first
    should_have_type(type, json)
  end

  def should_have_type(type, json = nil)
    type = TypeDecorator.decorate(type)
    should_have_valid_json
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json
    json.uri.should == type.uri
    json.id.should == type.id.as_json
    json.name.should == type.name
    json.public.should == type.public

    properties = Property.in(_id: type.property_ids)
    json.properties.each_with_index do |json_property, index|
      should_have_property(properties[index], json_property)
    end

    functions = Function.in(_id: type.function_ids)
    json.functions.each_with_index do |json_function, index|
      should_have_function(functions[index], json_function)
    end

    statuses = Status.in(_id: type.status_ids)
    json.statuses.each_with_index do |json_status, index|
      should_have_status(statuses[index], json_status)
    end

    categories = Category.in(_id: type.category_ids)
    json.categories.each_with_index do |json_category, index|
      should_have_category(categories[index], json_category)
    end
  end

  def should_not_have_not_owned_types
    should_have_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Type.all.should have(2).items
  end

end

RSpec.configuration.include TypesViewMethods
