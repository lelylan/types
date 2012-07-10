module PropertiesViewMethods

  def should_have_owned_property(property)
    property = PropertyDecorator.decorate(property)
    json = JSON.parse(page.source)
    should_contain_property(property)
    should_not_have_not_owned_properties
  end

  def should_contain_property(property)
    property = PropertyDecorator.decorate(property)
    json = JSON.parse(page.source).first
    should_have_property(property, json)
  end

  def should_have_property(property, json = nil)
    property = PropertyDecorator.decorate(property)
    should_have_valid_json
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json
    json.uri.should == property.uri
    json.id.should == property.id.as_json
    json.name.should == property.name
    json[:default].should == property.default
    json[:values].should == property.values
    json.created_at.should == property.created_at.iso8601
    json.updated_at.should == property.created_at.iso8601
  end

  def should_not_have_not_owned_properties
    should_have_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Property.all.should have(2).items
  end

end

RSpec.configuration.include PropertiesViewMethods
