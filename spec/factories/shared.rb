FactoryGirl.define do
  trait :with_no_properties do
    before(:create) do |resource|
      resource.properties = []
    end
  end
end
