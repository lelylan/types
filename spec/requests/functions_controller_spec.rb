require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'FunctionsController' do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, application: application, scopes: 'resources', resource_owner_id: user.id }

  before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }
  before { page.driver.header 'Content-Type', 'application/json' }

  let(:controller) { 'functions' }
  let(:factory)    { 'function' }

  describe 'GET /functions' do

    let!(:resource)  { FactoryGirl.create :function, resource_owner_id: user.id }
    let(:uri)        { '/functions' }

    it_behaves_like 'a listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /functions/public' do

    let!(:resource)  { FactoryGirl.create :function, resource_owner_id: user.id }
    let(:uri)        { '/functions/public' }

    it_behaves_like 'a public listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /functions/:id' do

    let!(:resource)  { FactoryGirl.create :function, resource_owner_id: user.id }
    let(:uri)        { "/functions/#{resource.id}" }

    it_behaves_like 'a showable resource'
    it_behaves_like 'a proxiable service'
    it_behaves_like 'a public resource', 'page.driver.get(uri)'
    it_behaves_like 'a not found resource', 'page.driver.get(uri)'
  end

  context 'POST /functions' do

    let(:uri)      { '/functions' }

    let(:status)     { FactoryGirl.create :status }
    let(:intensity)  { FactoryGirl.create :intensity }
    let(:properties) { [ { uri: a_uri(status), value: 'on' }, { uri: a_uri(intensity) } ] }
    let(:params)     { { name: 'Set intensity', properties: properties } }

    before         { page.driver.post uri, params.to_json }
    let(:resource) { Function.last }

    let(:json)     { Hashie::Mash.new JSON.parse(page.source) }

    it 'has two connected properties' do
      json.properties.should have(2).items
    end

    it_behaves_like 'a creatable resource'
    it_behaves_like 'a validated resource', 'page.driver.post(uri, {}.to_json)', { method: 'POST', error: 'can\'t be blank' }
  end

  context 'PUT /functions/:id' do

    let!(:resource) { FactoryGirl.create :function, resource_owner_id: user.id }
    let(:uri)       { "/functions/#{resource.id}" }
    let(:params)    { { name: 'Updated' } }

    it_behaves_like 'an updatable resource'
    it_behaves_like 'a not owned resource', 'page.driver.put(uri)'
    it_behaves_like 'a not found resource', 'page.driver.put(uri)'
    it_behaves_like 'a validated resource', 'page.driver.put(uri, {name: ""}.to_json)', { method: 'PUT', error: 'can\'t be blank' }
  end

  context 'DELETE /functions/:id' do
    let!(:resource)  { FactoryGirl.create :function, resource_owner_id: user.id }
    let(:uri)        { "/functions/#{resource.id}" }

    it_behaves_like 'a deletable resource'
    it_behaves_like 'a not owned resource', 'page.driver.delete(uri)'
    it_behaves_like 'a not found resource', 'page.driver.delete(uri)'
  end
end
