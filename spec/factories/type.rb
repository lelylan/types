FactoryGirl.define do
  factory :type, aliases: %w(dimmer) do
    name 'Dimmer'
    description 'Description'
    resource_owner_id Settings.resource_owner_id
    property_ids {[ FactoryGirl.create('status').id, FactoryGirl.create('intensity').id ]}
    function_ids {[ FactoryGirl.create('set_intensity').id, FactoryGirl.create('turn_on').id, FactoryGirl.create('turn_off').id ]}
    status_ids   {[ FactoryGirl.create('setting_intensity').id, FactoryGirl.create('setting_intensity').id ]}
  end

  trait :with_no_connections do
    property_ids []
    function_ids []
    status_ids   []
  end
end
