shared_examples_for 'a changeable host' do

  let(:decorator)  { "#{controller.classify}Decorator".constantize }
  let(:changeable) { decorator.decorate(resource) }

  it 'exposes the resource URI' do
    page.driver.get uri
    uri = "http://www.example.com/#{controller}/#{changeable.id}"
    changeable.uri.should == uri
  end

  # TODO find the way to set the header HTTP_HOST for rack (Host does not work)
  #context 'with host' do

    #before { page.driver.header 'HTTP_HOST', 'http://api.lelylan.com' }

    #it 'changes the URI' do
      #page.driver.get uri
      #changeable.uri.should match('http://api.lelylan.com')
    #end
  #end
end
