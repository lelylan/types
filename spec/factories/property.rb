FactoryGirl.define do
  factory :property, aliases: %w(status) do
    resource_owner_id { FactoryGirl.create(:user).id }
    name 'Status'
    default 'off'
    suggested { { 'on' => 'On', 'off' => 'Off' } }
  end

  factory :intensity, parent: :property do
    resource_owner_id { FactoryGirl.create(:user).id }
    name 'Intensity'
    default '0'
    type 'range'
    suggested nil
    range { { 'min' => '0', 'max' => '100', 'step' => '1' } }
  end
end
