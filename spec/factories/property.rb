Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :intensity, class: :property do
    uri Settings.properties.intensity.uri
    created_from Settings.user.uri
    name Settings.properties.intensity.name
    default Settings.properties.intensity.default_value
    values Settings.properties.intensity.values
  end

  factory :not_owned_intensity, parent: :intensity do
    created_from Settings.another_user.uri
    uri Settings.properties.intensity.uri + 'not_owned'
  end

  factory :status, class: :property do
    uri Settings.properties.status.uri
    created_from Settings.user.uri
    name Settings.properties.status.name
    default Settings.properties.status.default_value
    values Settings.properties.status.values
  end
end
