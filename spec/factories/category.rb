Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :category do
    name Settings.category.name
    uri Settings.category.uri
    created_from Settings.user.uri
  end

  factory :not_owned_category, parent: :category do
    uri Settings.category.uri + 'not_owned'
    created_from Settings.another_user.uri
  end
end

