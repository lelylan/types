FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/status'
    matches ['on']
    pending false
  end

  factory :intensity_for_status, class: StatusProperty do
    uri 'https://api.lelylan.com/properties/intensity'
    matches ['0..100']
    pending true
  end
end
