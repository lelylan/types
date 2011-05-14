Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :status do
    name Settings.status.name
    uri Settings.status.uri
    created_from Settings.user.uri
  end
end
