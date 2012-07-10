Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # base

  factory :setting_intensity, class: Status do
    name Settings.statuses.setting_intensity.name 
    created_from Settings.user.uri
  end

  factory :status_not_owned, parent: :setting_intensity do
    created_from Settings.user.another.uri
  end

  # connections 

  trait :with_status_properties do
    after :create do |status|
      FactoryGirl.create :status_for_setting_intensity, status: status
      FactoryGirl.craete :function_property_intensity, status: status
    end
  end

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
