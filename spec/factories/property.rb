Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # Property
  factory :property do
    name 'Status'
    created_from Settings.user.uri
    default Settings.properties.status.default
    values Settings.properties.status.values
  end

  # Property not owned
  factory :property_not_owned, parent: :property do
    created_from Settings.user.another.uri
  end 

  # Status property
  factory :status, parent: :property

  # Intensity property
  factory :intensity, parent: :property do
    name 'Intensity'
    default Settings.properties.intensity.default
    values Settings.properties.intensity.values
  end
end
