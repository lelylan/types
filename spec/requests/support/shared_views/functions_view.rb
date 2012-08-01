module FunctionsViewMethods

  def should_have_owned_function(function)
    function = FunctionDecorator.decorate(function)
    json = JSON.parse(page.source)
    should_contain_function(function)
    should_not_have_not_owned_functions
  end

  def should_contain_function(function)
    function = FunctionDecorator.decorate(function)
    json = JSON.parse(page.source).first
    should_have_function(function, json)
  end

  def should_have_function(function, json = nil)
    function = FunctionDecorator.decorate(function)
    should_have_valid_json
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json
    json.uri.should == function.uri
    json.id.should == function.id.as_json
    json.name.should == function.name
    json.properties.each_with_index do |json_property, index|
      property = FunctionPropertyDecorator.decorate(function.properties[index])
      json_property.uri.should == property.uri
      json_property.value.should == property.value
    end
    json.created_at.should == function.created_at.iso8601
    json.updated_at.should == function.created_at.iso8601
  end

  def should_not_have_not_owned_functions
    should_have_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Function.all.should have(2).items
  end

end

RSpec.configuration.include FunctionsViewMethods
