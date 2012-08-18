FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/status'
    values ['on']
  end

  factory :intensity_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/intensity'
    min '0'
    max  '100'
  end
end
