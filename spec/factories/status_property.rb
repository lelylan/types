FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/status'
    values ['on']
  end

  factory :intensity_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/intensity'
    min_range '0'
    max_range   '100'
  end
end
