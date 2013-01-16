FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    uri { "https://api.lelylan.com/properties/#{FactoryGirl.create(:status).id}" }
    value ['on']
    pending false
  end

  factory :intensity_for_status, class: StatusProperty do
    uri { "https://api.lelylan.com/properties/#{FactoryGirl.create(:intensity).id}" }
    value ['0..100']
    pending true
  end
end
