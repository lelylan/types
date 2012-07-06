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
    json.properties.each_with_index do |json_property, index|
      property = TypePropertyDecorator.decorate(type.type_properties[index])
      json_property.uri.should == property.uri
      json_property.value.should == property.value
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
