Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # -----------------
  # Base factories
  # -----------------

  factory :setting_intensity, class: Status do
    name 'Setting intensity'
    created_from Settings.user.uri
    status_properties {[
      FactoryGirl.build(:status_for_setting_intensity),
      FactoryGirl.build(:intensity_for_setting_intensity)
    ]}
  end

  factory :status_no_connections, parent: :setting_intensity do
    status_properties []
  end

  factory :status_not_owned, parent: :setting_intensity do
    created_from Settings.user.another.uri
  end

  # --------------
  # Connections
  # --------------

  factory :status_for_setting_intensity, class: StatusProperty do
    property_id Settings.properties.status.property_id
    values ['on']
    pending nil
  end

  factory :intensity_for_setting_intensity, class: StatusProperty do
    property_id Settings.properties.intensity.property_id
    range_start '0'
    range_end '100'
    pending 'true'
  end
end
