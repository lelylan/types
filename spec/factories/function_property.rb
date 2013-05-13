FactoryGirl.define do
  factory :status_for_function, class: FunctionProperty do
    id { FactoryGirl.create(:status).id }
    expected 'on'
  end

  factory :intensity_for_function, class: FunctionProperty do
    id { FactoryGirl.create(:intensity).id }
    expected '0'
  end
end
