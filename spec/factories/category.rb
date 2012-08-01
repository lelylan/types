FactoryGirl.define do
  factory :category, aliases: %w(lighting) do
    resource_owner_id Settings.resource_owner_id
    name 'Lighting'
  end
end
