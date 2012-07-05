Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # Function
  factory :function do
    created_from Settings.user.uri
    name Settings.functions.set_intensity.name
    function_properties {[
      FactoryGirl.build(:function_status),
      FactoryGirl.build(:function_intensity)
    ]}
  end

  # Function with no connections
  factory :function_no_connections, parent: :function do |f|
    function_properties []
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
    name Settings.functions.turn_on.name
    function_properties {[ 
      FactoryGirl.build(:function_status, value: 'on') 
    ]}
  end

  factory :turn_off, parent: :function do |f|
    name Settings.functions.turn_off.name
    function_properties {[ 
      FactoryGirl.build(:function_status, value: 'off') 
    ]}
  end

  # --------------
  # Connections
  # --------------

  factory :function_status, class: :function_property do
    property_id Settings.properties.status.property_id
    value Settings.properties.status.default
  end

  factory :function_intensity, class: :function_property do
    property_id Settings.properties.intensity.property_id
    value Settings.properties.intensity.default
  end
end
