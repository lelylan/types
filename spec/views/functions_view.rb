module HelpersViewMethods
  def has_function(function, json = nil)
    json.uri.should == function.uri
    json.id.should == function.id.as_json
    json.name.should == function.name
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil

    json.properties.each_with_index do |json_property, i|
      property = FunctionPropertyDecorator.decorate function.properties[i]
      json_property.id.should == property.property_id.as_json
      json_property.uri.should == property.uri
      json_property.expected.should == property.expected
      json_property.pending.should == true
    end
  end
end

RSpec.configuration.include HelpersViewMethods
