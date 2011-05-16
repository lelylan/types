Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  # Is setting intensity/max
  factory :is_setting_intensity, class: Status do
    name Settings.statuses.is_setting_intensity.name
    uri Settings.statuses.is_setting_intensity.uri
    created_from Settings.user.uri
    status_properties {[ Factory.build(:status_property_is_setting_intensity) ]}
  end

  factory :is_setting_max, parent: :is_setting_intensity do
    status_properties {[ Factory.build(:status_property_is_setting_max) ]}
  end

  factory :not_owned_is_setting_intensity, parent: :is_setting_intensity do
    uri Settings.statuses.is_setting_intensity.uri + 'not_owned'
    created_from Settings.another_user.uri
  end

  # Has set intensity/max
  factory :has_set_intensity, class: :status do
    name Settings.statuses.has_set_intensity.name
    uri Settings.statuses.has_set_intensity.uri
    created_from Settings.user.uri
    status_properties {[ Factory.build(:status_property_has_set_intensity) ]}
  end

  factory :has_set_max, parent: :has_set_intensity do
    status_properties {[ Factory.build(:status_property_has_get_max) ]}
  end

  factory :not_owned_has_set_intensity, parent: :has_set_intensity do
    uri Settings.statuses.has_set_intensity.uri + 'not_owned'
    created_from Settings.another_user.uri
  end


  # Connections
  factory :status_property_has_set_intensity, class: StatusProperty do
    uri Settings.properties.intensity.uri
    values Settings.statuses.has_set_intensity.values
    pending 'false'
  end

  factory :status_property_is_setting_intensity, parent: :status_property_has_set_intensity do
    values Settings.statuses.is_setting_intensity.values
    pending 'true'
  end

  factory :status_property_has_set_max, class: StatusProperty do
    uri Settings.properties.intensity.uri
    values Settings.statuses.has_set_max.values
    pending 'false'
  end

  factory :status_property_is_setting_max, parent: :status_property_has_set_max do
    values Settings.statuses.is_setting_max.values
    pending 'true'
  end
end  
