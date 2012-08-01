shared_examples_for 'a not found resource' do |model, action|

  context 'with not existing resource' do

    scenario 'get a not found notification' do
      resource.delete
      eval action
      has_valid_json
      has_not_found_resource uri: uri
    end
  end

  context 'with illegal id' do

    let(:uri) { "/#{model.pluralize}/0" }

    scenario 'get a not found notification' do
      eval action
      has_valid_json
      has_not_found_resource uri: uri
    end
  end
end
