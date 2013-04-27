module HelpersViewMethods
  def has_property(property, json = nil)
    json.uri.should == property.uri
    json.id.should == property.id.as_json
    json.name.should == property.name
    json.type.should == property.type
    json[:default].should == property.default
    json.accepted.should == (property.suggested ? Hashie::Mash.new(property.suggested) : nil)
    json.range.should == Hashie::Mash.new(property.range) if (property.range)
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil
  end
end

RSpec.configuration.include HelpersViewMethods
