module TypesViewMethods

  def contains_owned_type(type)
    type = TypeDecorator.decorate(type)
    json = JSON.parse(page.source)
    contains_type(type)
  end

  def contains_type(type)
    type = TypeDecorator.decorate(type)
    json = JSON.parse(page.source).first
    has_type(type, json)
  end

  def has_type(type, json = nil)
    has_valid_json

    type = TypeDecorator.decorate(type)
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json

    json.uri.should  == type.uri
    json.id.should   == type.id.as_json
    json.name.should == type.name

    properties = Property.in(_id: type.property_ids)
    json.properties.each_with_index do |json_property, index|
      has_property(properties[index], json_property)
    end

    functions = Function.in(_id: type.function_ids)
    json.functions.each_with_index do |json_function, index|
      has_function(functions[index], json_function)
    end

    statuses = Status.in(_id: type.status_ids)
    json.statuses.each_with_index do |json_status, index|
      has_status(statuses[index], json_status)
    end

    categories = Category.in(_id: type.category_ids)
    json.categories.each_with_index do |json_category, index|
      has_category(categories[index], json_category)
    end
  end

  def does_not_contain_type(type) 
    page.should_not have_content type.id.to_s
  end
end

RSpec.configuration.include TypesViewMethods
