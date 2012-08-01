shared_examples_for 'a changeable host' do |model|

  let(:changeable) { "#{model.classify}Decorator".constantize.decorate(resource) }

  it 'exposes the resource URI' do
    page.driver.get uri
    uri = "http://www.example.com/#{model.pluralize}/#{changeable.id}"
    changeable.uri.should == uri
  end

  context 'with host' do

    it 'changes the URI' do
      page.driver.get uri, host: 'http://www.lelylan.com'
      changeable.uri.should match('http://www.lelylan.com')
    end
  end
end
