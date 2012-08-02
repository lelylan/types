module HelpersViewMethods
  def has_status(status, json = nil)
    has_valid_json

    status = StatusDecorator.decorate(status)
    json   = JSON.parse(page.source) unless json 
    json   = Hashie::Mash.new json

    json.uri.should  == status.uri
    json.id.should   == status.id.as_json
    json.name.should == status.name
    json[:pending].should  == status.pending
    json.created_at.should == status.created_at.iso8601
    json.updated_at.should == status.created_at.iso8601

    json.properties.each_with_index do |json_property, i|
      property = StatusPropertyDecorator.decorate(status.properties[i])
      json_property.uri.should       == property.uri
      json_property[:values].should  == property.values
      json_property.min_range.should == property.min_range
      json_property.max_range.should == property.max_range
    end
  end
end

RSpec.configuration.include HelpersViewMethods
