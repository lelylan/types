module HelpersViewMethods
  def has_type(type, json = nil)
    json.uri.should  == type.uri
    json.id.should   == type.id.as_json
    json.name.should == type.name
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil

    if json.properties
      properties = Property.in(_id: type.property_ids)
      json.properties.each_with_index do |json_property, i|
        has_property PropertyDecorator.decorate(properties[i]), json_property
      end
    end

    if json.functions
      functions = Function.in(_id: type.function_ids)
      json.functions.each_with_index do |json_function, i|
        has_function FunctionDecorator.decorate(functions[i]), json_function
      end
    end

    if json.statuses
      statuses = Status.in(_id: type.status_ids)
      json.statuses.each_with_index do |json_status, i|
        has_status StatusDecorator.decorate(statuses[i]), json_status
      end
    end
  end
end

RSpec.configuration.include HelpersViewMethods
