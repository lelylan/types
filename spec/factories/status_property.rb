FactoryGirl.define do
  factory :status_for_status, class: StatusProperty do
    values ['on']
  end

  factory :intensity_for_status, class: StatusProperty do
    range_start '0'
    range_end   '100'
  end
end
