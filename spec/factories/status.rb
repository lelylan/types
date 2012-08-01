FactoryGirl.define do
  factory :setting_intensity, class: Status do
    resource_owner_id Settings.resource_owner_id
    name 'Setting intensity'
    pending true
    properties {[
      FactoryGirl.create :status_for_status,
      FactoryGirl.create :intensity_for_status,
    ]}
  end
end
