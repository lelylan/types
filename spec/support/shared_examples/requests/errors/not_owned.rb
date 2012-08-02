shared_examples_for 'a not owned resource' do |action|

  context 'with resource not owned' do

    let(:uri) { "/#{controller}/#{not_owned.id}" }

    scenario 'get a not found notification' do
      eval action
      has_valid_json
      has_not_found_resource uri: uri
    end
  end
end
