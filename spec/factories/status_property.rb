FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/status'
    value ['on']
    pending false
  end

  factory :intensity_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/intensity'
    value ['0..100']
    pending true
  end
end
