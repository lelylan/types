Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :category do
    name Settings.category.name
    uri Settings.category.uri
    created_from Settings.user.uri
  end

  factory :cooling_category, parent: :category do
    uri Settings.category.cooling.uri
  end

  factory :category_public, parent: :category do
    uri Settings.category.uri + '_public'
    public true
  end

  factory :not_owned_category, parent: :category do
    uri Settings.category.uri + '_not_owned'
    created_from Settings.another_user.uri
  end

  factory :not_owned_public_category, parent: :not_owned_category do
    uri Settings.category.uri + '_not_owned_public'
    public true
  end
end

