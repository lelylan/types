module HelpersViewMethods
  def has_property(property, json = nil)
    json.uri.should  == property.uri
    json.id.should   == property.id.as_json
    json.name.should == property.name
    json[:default].should == property.default
    json.suggested.should == Hashie::Mash.new(property.suggested)
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil
  end
end

RSpec.configuration.include HelpersViewMethods
