Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # base

  factory :function do
    name Settings.functions.set_intensity.name
    created_from Settings.user.uri
  end

  factory :function_not_owned, parent: :function do
    created_from Settings.user.another.uri
  end

  factory :set_intensity, parent: :function

  factory :turn_on, parent: :function do |f|
    name Settings.functions.turn_on.name
    properties {[
      FactoryGirl.build(:function_property_status, value: 'on')
    ]}
  end

  factory :turn_off, parent: :function do |f|
    name Settings.functions.turn_off.name
    properties {[
      FactoryGirl.build(:function_property_status, value: 'off')
    ]}
  end

  # connections

  trait :with_properties do
    after :create do |function|
      FactoryGirl.create :function_property_status, function: function
      FactoryGirl.create :function_property_intensity, function: function
    end
  end

  factory :function_property_status, class: FunctionProperty do
    uri Settings.properties.status.uri
    value 'on'
  end

  factory :function_property_intensity, class: FunctionProperty do
    uri Settings.properties.intensity.uri
    value '0'
  end
end
