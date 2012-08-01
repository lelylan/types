FactoryGirl.define do
  factory :type, aliases: %w(dimmer) do
    name 'Dimmer'
    resource_owner_id Settings.resource_owner_id
  end
end
