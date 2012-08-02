module HelpersViewMethods
  def has_property(property, json = nil)
    json.uri.should  == property.uri
    json.id.should   == property.id.as_json
    json.name.should == property.name
    json[:default].should  == property.default
    json[:values].should   == property.values
    json.created_at.should == property.created_at.iso8601
    json.updated_at.should == property.created_at.iso8601
  end
end

RSpec.configuration.include HelpersViewMethods
