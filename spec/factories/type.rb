FactoryGirl.define do
  factory :type, aliases: %w(dimmer) do
    name 'Dimmer'
    resource_owner_id Settings.resource_owner_id
    property_ids [ 'status', 'intensity' ]
    function_ids [ 'set_intensity', 'turn_on', 'turn_off' ]
    status_ids   [ 'setting_intensity', 'turning_on' ]
  end

  trait :with_no_connections do
    property_ids []
    function_ids []
    status_ids   []
  end
end
