module FunctionsViewMethods

  def contains_owned_function(function)
    function = FunctionDecorator.decorate(function)
    json     = JSON.parse(page.source)
    contains_function(function)
  end

  def contains_function(function)
    function = FunctionDecorator.decorate(function)
    json     = JSON.parse(page.source).first
    has_function(function, json)
  end

  def has_function(function, json = nil)
    has_valid_json

    function = FunctionDecorator.decorate(function)
    json     = JSON.parse(page.source) unless json 
    json     = Hashie::Mash.new json

    json.uri.should  == function.uri
    json.id.should   == function.id.to_s
    json.name.should == function.name
    json.created_at.should == function.created_at.iso8601
    json.updated_at.should == function.created_at.iso8601

    json.properties.each_with_index do |json_property, i|
      property = FunctionPropertyDecorator.decorate(function.properties[i])
      json_property.uri.should   == property.uri
      json_property.value.should == property.value
    end
  end

  def does_not_contain_function(function)
    page.should_not have_content function.id.to_s
  end

end

RSpec.configuration.include FunctionsViewMethods
