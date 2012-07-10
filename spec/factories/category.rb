Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  factory :category do
    name 'Lighting'
    created_from Settings.user.uri
  end

  factory :category_not_owned, parent: :category do
    created_from Settings.user.another.uri
  end 
end
