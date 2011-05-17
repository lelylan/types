Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :type do
    uri Settings.type.uri
    created_from Settings.user.uri
    name Settings.type.name
    properties [
      Settings.properties.intensity.uri,
      Settings.properties.status.uri ]
    functions [
      Settings.functions.set_intensity.uri,
      Settings.functions.turn_on.uri,
      Settings.functions.turn_off.uri ]
    statuses [
      Settings.statuses.is_setting_max.uri,
      Settings.statuses.has_set_max.uri,
      Settings.statuses.is_setting_intensity.uri,
      Settings.statuses.has_set_intensity.uri ]
    type_statuses {[ Factory.build(:default_type_status) ]}
  end

  factory :not_owned_type, parent: :type do
    created_from Settings.another_user.uri
    uri Settings.properties.intensity.uri + 'not_owned'
  end

  factory :default_type_status, class: :type_status do
    uri Settings.statuses.default.uri
    order Settings.statuses.default_order
  end
end

