FactoryGirl.define do
  factory :function, aliases: %w(set_intensity) do
    resource_owner_id Settings.resource_owner_id
    name 'Set intensity'
    properties {[
      FactoryGirl.build(:status_for_function),
      FactoryGirl.build(:intensity_for_function)
    ]}
  end

  factory :turn_on, parent: :function do
    resource_owner_id Settings.resource_owner_id
    name 'Turn on'
    properties {[
      FactoryGirl.build(:status_for_function)
    ]}
  end

  factory :turn_off, parent: :function do
    resource_owner_id Settings.resource_owner_id
    name 'Turn off'
    properties {[
      FactoryGirl.build(:status_for_function)
    ]}
  end
end
