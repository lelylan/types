FactoryGirl.define do
  factory :setting_intensity, class: Status do
    resource_owner_id Settings.resource_owner_id
    name 'Setting intensity'
    properties {[
      FactoryGirl.build(:status_for_status),
      FactoryGirl.build(:intensity_for_status)
    ]}
  end
end
