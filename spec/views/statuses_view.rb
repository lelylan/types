module HelpersViewMethods
  def has_status(status, json = nil)
    json.uri.should  == status.uri
    json.id.should   == status.id.as_json
    json.name.should == status.name
    json[:pending].should  == status.pending
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil

    json.properties.each_with_index do |json_property, i|
      property = StatusPropertyDecorator.decorate(status.properties[i])
      json_property.uri.should == property.uri
      json_property[:values].should  == property.values ? property.values : nil
      if (property.min or property.max)
        json_property.range[:min].should == property.min ? property.min : nil
        json_property.range[:max].should == property.max ? property.max : nil
      else
        json_property.range.should == nil
      end
    end
  end
end

RSpec.configuration.include HelpersViewMethods
