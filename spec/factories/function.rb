FactoryGirl.define do
  factory :function, aliases: %w(set_intensity) do
    resource_owner_id { FactoryGirl.create(:user).id }
    name 'Set intensity'
    properties {[
      FactoryGirl.build(:status_for_function),
      FactoryGirl.build(:intensity_for_function)
    ]}
  end

  factory :turn_on, parent: :function do
    resource_owner_id { FactoryGirl.create(:user).id }
    name 'Turn on'
    properties {[
      FactoryGirl.build(:status_for_function)
    ]}
  end

  factory :turn_off, parent: :function do
    resource_owner_id { FactoryGirl.create(:user).id }
    name 'Turn off'
    properties {[
      FactoryGirl.build(:status_for_function)
    ]}
  end
end
