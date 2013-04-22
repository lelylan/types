module HelpersViewMethods
  def has_status(status, json = nil)
    json.uri.should == status.uri
    json.id.should == status.id.as_json
    json.name.should == status.name
    json.function.id.should == (status.function_id ? status.function_id.as_json : nil)
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil

    json.properties.each_with_index do |json_property, i|
      property = StatusPropertyDecorator.decorate(status.properties[i])
      json_property.uri.should       == property.uri
      json_property.value.should     == property.value
      json_property[:pending].should == property.pending
    end
  end
end

RSpec.configuration.include HelpersViewMethods
