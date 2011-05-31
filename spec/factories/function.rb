Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :function do
    uri Settings.functions.set_intensity.uri
    created_from Settings.user.uri
    name Settings.functions.set_intensity.name
  end

  factory :not_owned_function, parent: :function do
    created_from Settings.another_user.uri
  end

  factory :function_complete, parent: :function do |f|
    f.function_properties {[
      Factory.build(:function_status),
      Factory.build(:function_intensity)
    ]}
  end

  # Function specific
  factory :set_intensity, parent: :function do |f|
    uri Settings.functions.set_intensity.uri
    name Settings.functions.set_intensity.name
    f.function_properties {[
      Factory.build(:function_status),
      Factory.build(:function_intensity)
    ]}
  end

  factory :turn_on, parent: :function do |f|
    uri Settings.functions.turn_on.uri
    name Settings.functions.turn_on.name
    f.function_properties {[ Factory.build(:function_status, value: 'on') ]}
  end

  factory :turn_off, parent: :function do |f|
    uri Settings.functions.turn_off.uri
    name Settings.functions.turn_off.name
    f.function_properties {[ Factory.build(:function_status, value: 'off') ]}
  end

  # Connections
  factory :function_status, class: :function_property do
    uri Settings.properties.status.uri
    value Settings.properties.status.default_value
    secret false
    filter ''
  end

  factory :function_intensity, class: :function_property do
    uri Settings.properties.intensity.uri
    value ''
    secret true
    filter 'before'
  end
end
