module HelpersViewMethods
  def has_category(category, json = nil)
    json.uri.should  == category.uri
    json.id.should   == category.id.to_s
    json.name.should == category.name
    json.created_at.should_not be_nil
    json.updated_at.should_not be_nil
  end
end

RSpec.configuration.include HelpersViewMethods
