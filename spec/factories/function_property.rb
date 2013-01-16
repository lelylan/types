FactoryGirl.define do
  factory :status_for_function, class: FunctionProperty do
    uri { "https://api.lelylan.com/properties/#{FactoryGirl.create(:status).id}" }
    expected 'on'
  end

  factory :intensity_for_function, class: FunctionProperty do
    uri { "https://api.lelylan.com/properties/#{FactoryGirl.create(:intensity).id}" }
    expected '0'
  end
end
