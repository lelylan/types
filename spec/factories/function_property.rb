FactoryGirl.define do
  factory :status_for_function, class: FunctionProperty do
    uri 'https://api.lelylan.com/properties/status'
    expected 'on'
  end

  factory :intensity_for_function, class: FunctionProperty do
    uri 'https://api.lelylan.com/properties/intensity'
    expected '0'
  end
end
