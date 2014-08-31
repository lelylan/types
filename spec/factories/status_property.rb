FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    id { FactoryGirl.create(:status).id }
    values ['on']
    pending false
  end

  factory :intensity_for_status, class: StatusProperty do
    id { FactoryGirl.create(:intensity).id }
    ranges { [ { 'min' => 0, 'max' => 10 } ] }
    pending true
  end
end
