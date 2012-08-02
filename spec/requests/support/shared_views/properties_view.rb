module PropertiesViewMethods

  def contains_owned_property(property)
    property = PropertyDecorator.decorate(property)
    json     = JSON.parse(page.source)
    contains_property(property)
  end

  def contains_property(property)
    property = PropertyDecorator.decorate(property)
    json     = JSON.parse(page.source).first
    has_property(property, json)
  end

  def has_property(property, json = nil)
    has_valid_json

    property = PropertyDecorator.decorate(property)
    json     = JSON.parse(page.source) unless json 
    json     = Hashie::Mash.new json

    json.uri.should  == property.uri
    json.id.should   == property.id.as_json
    json.name.should == property.name
    json[:default].should  == property.default
    json[:values].should   == property.values
    json.created_at.should == property.created_at.iso8601
    json.updated_at.should == property.created_at.iso8601
  end

  def does_not_contain_property(property)
    page.should_not have_content property.id.to_s
  end
end

RSpec.configuration.include PropertiesViewMethods
