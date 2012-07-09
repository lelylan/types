Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  # Function
  factory :function do
    created_from Settings.user.uri
    name Settings.functions.set_intensity.name
    properties [
      { uri: Settings.properties.status.uri, value: 'on' },
      { uri: Settings.properties.intensity.uri, value: '0' }
    ]
  end

  # Function with no connections
  factory :function_no_connections, parent: :function do |f|
    properties []
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
    properties [
      { uri: Settings.properties.status.uri, value: 'on' }
    ]
  end

  factory :turn_off, parent: :function do |f|
    name Settings.functions.turn_off.name
    properties [
      { uri: Settings.properties.status.uri, value: 'off' }
    ]
  end
end
