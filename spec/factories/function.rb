Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  factory :function do
    created_from Settings.user.uri
    name Settings.functions.set_intensity.name
  end

  factory :function_not_owned, parent: :function do
    created_from Settings.user.another.uri
  end

  factory :set_intensity, parent: :function

  factory :turn_on, parent: :function do |f|
    name Settings.functions.turn_on.name
    properties {[
      FunctionProperty.build(uri: Settings.properties.status.uri, value: 'on')
    ]}
  end

  factory :turn_off, parent: :function do |f|
    name Settings.functions.turn_off.name
    properties {[
      FunctionProperty.build(uri: Settings.properties.status.uri, value: 'off')
    ]}
  end

  trait :with_properties do
    after :create do |function|
      FactoryGirl.build :function_property_status, function: function
      FactoryGirl.build :function_property_intensity, function: function
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
