Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  # Type with all connections
  factory :type do
    uri Settings.type.uri
    created_from Settings.user.uri
    name Settings.type.name
    categories [ Settings.category.uri ]
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

  # Public Type
  factory :type_public, parent: :type do
    uri Settings.properties.intensity.uri + '_public'
    public true
  end

  # Not owned type
  factory :not_owned_type, parent: :type do
    uri Settings.properties.intensity.uri + '_not_owned'
    created_from Settings.another_user.uri
  end

  # Not owned public type
  factory :not_owned_type_public, parent: :type do
    uri Settings.properties.intensity.uri + '_not_owned_public'
    created_from Settings.another_user.uri
    public true
  end

  # ------------
  # Connections
  # ------------
  factory :default_type_status, class: :type_status do
    uri Settings.statuses.default.uri
    order Settings.statuses.default_order
  end
end

