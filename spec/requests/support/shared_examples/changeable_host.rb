shared_examples_for 'changeable host' do

  let(:changeable) { "#{resource.class.to_s}Decorator".constantize.decorate(resource) }

  it 'exposes the location URI' do
    page.driver.get uri
    uri = "http://www.example.com/locations/#{changeable.id}"
    changeable.uri.should == uri
  end

  context 'with host' do

    it 'changes the URI' do
      page.driver.get uri, host: 'http://www.lelylan.com'
      changeable.uri.should match('http://www.lelylan.com')
    end
  end
end
