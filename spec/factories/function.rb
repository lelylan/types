Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # Function
  factory :function do
    created_from Settings.user.uri
    name Settings.functions.set_intensity.name
    f.function_properties {[
      Factory.build(:function_status),
      Factory.build(:function_intensity)
    ]}
  end

  # Function with no connections
  factory :function_no_connections, parent: :function do |f|
    function_properties = []
  end

  # Function not owned
  factory :function_not_owned, parent: :function do
    created_from Settings.user.another.uri
  end

  # --------------------
  # Function specific
  # --------------------

  factory :set_intensity, parent: :function

  factory :turn_on, parent: :function do |f|
    uri Settings.functions.turn_on.uri
    name Settings.functions.turn_on.name
    f.function_properties {[ 
      Factory.build(:function_status, value: 'on') 
    ]}
  end

  factory :turn_off, parent: :function do |f|
    uri Settings.functions.turn_off.uri
    name Settings.functions.turn_off.name
    f.function_properties {[ 
      Factory.build(:function_status, value: 'off') 
    ]}
  end

  # --------------
  # Connections
  # --------------

  factory :function_status, class: :function_property do
    uri Settings.properties.status.uri
    value Settings.properties.status.default_value
  end

  factory :function_intensity, class: :function_property do
    uri Settings.properties.intensity.uri
    value Settings.properties.intensity.default_value
  end
end
