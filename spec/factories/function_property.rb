FactoryGirl.define do
  factory :status_for_function, class: FunctionProperty do
    value 'on'
  end

  factory :intensity_for_function, class: FunctionProperty do
    value '0'
  end
end
