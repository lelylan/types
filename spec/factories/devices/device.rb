FactoryGirl.define do
  factory :device do
    resource_owner_id { FactoryGirl.create(:user).id }
    type_id { FactoryGirl.create(:type).id }
    name 'Closet dimmer'
    category 'lights'
    properties {[
      FactoryGirl.build(:device_status, property_id: Type.find(type_id).property_ids.first),
      FactoryGirl.build(:device_intensity, property_id: Type.find(type_id).property_ids.last)
    ]}
  end
end
