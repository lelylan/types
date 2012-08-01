shared_examples_for 'a public resource' do |model|

  let(:uri) { "/#{model.pluralize}/#{not_owned.id}" }

  it 'does not create a resource' do
    page.driver.get uri
    page.status_code.should == 200
  end
end
