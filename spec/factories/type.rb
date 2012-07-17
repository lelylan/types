Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do

  factory :type, class: Type do
    name 'Dimmer'
    created_from Settings.user.uri
    properties {[
      Settings.properties.status.uri, 
      Settings.properties.intensity.uri
    ]}
  end

  factory :type_no_connections, parent: :type do
    properties []
  end

  factory :type_not_owned, parent: :type do
    created_from Settings.user.another.uri
  end

  factory :dimmer, parent: :type
end
