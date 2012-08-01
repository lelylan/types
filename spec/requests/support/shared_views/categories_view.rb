module CategoriesViewMethods

  def contains_owned_category(category)
    category = CategoryDecorator.decorate category
    json     = JSON.parse page.source
    contains_category category
    has_not_not_owned_categories
  end

  def contains_category(category)
    category = CategoryDecorator.decorate category
    json     = JSON.parse(page.source).first
    has_category category, json
  end

  def has_category(category, json = nil)
    has_valid_json

    category = CategoryDecorator.decorate category
    json = JSON.parse page.source unless json 
    json = Hashie::Mash.new json

    json.uri.should  == category.uri
    json.id.should   == category.id.as_json
    json.name.should == category.name
    json.created_at.should == category.created_at.iso8601
    json.updated_at.should == category.updated_at.iso8601
  end

  def has_not_not_owned_categories
    has_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Category.all.should have(2).items
  end
end

RSpec.configuration.include CategoriesViewMethods
