shared_examples_for 'a searchable resource' do |model, searchable|

  searchable.each do |key, value|

    describe "?#{key}=:#{key}" do

      let!(:result) { FactoryGirl.create model, key => value, resource_owner_id: user.id.to_s }

      it 'returns the searched resource' do
        page.driver.get uri, key => value
        eval "contains_#{model}(result)"
        page.should_not have_content resource[key]
      end
    end
  end
end

