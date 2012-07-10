module CategoriesViewMethods

  def should_have_owned_category(category)
    category = CategoryDecorator.decorate(category)
    json = JSON.parse(page.source)
    should_contain_category(category)
    should_not_have_not_owned_categories
  end

  def should_contain_category(category)
    category = CategoryDecorator.decorate(category)
    json = JSON.parse(page.source).first
    should_have_category(category, json)
  end

  def should_have_category(category, json = nil)
    category = CategoryDecorator.decorate(category)
    should_have_valid_json
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json
    json.uri.should == category.uri
    json.id.should == category.id.as_json
    json.name.should == category.name
  end

  def should_not_have_not_owned_categories
    should_have_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Category.all.should have(2).items
  end

end

RSpec.configuration.include CategoriesViewMethods
