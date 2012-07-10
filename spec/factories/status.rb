Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  factory :setting_intensity, class: Status do
    name Settings.statuses.setting_intensity.name 
    pending 'true'
    created_from Settings.user.uri
    properties {[
      FactoryGirl.build(:status_for_setting_intensity),
      FactoryGirl.build(:intensity_for_setting_intensity)
    ]}
  end

  factory :setting_intensity_no_connections, parent: :setting_intensity do
    properties []
  end

  factory :status_not_owned, parent: :setting_intensity do
    created_from Settings.user.another.uri
  end

  factory :status_for_setting_intensity, class: StatusProperty do
    uri Settings.properties.status.uri
    values ['on']
  end

  factory :intensity_for_setting_intensity, class: StatusProperty do
    uri Settings.properties.intensity.uri
    range_start '0'
    range_end '100'
  end
end
