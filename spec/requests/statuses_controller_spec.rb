require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'StatusesController' do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, application: application, scopes: 'resources', resource_owner_id: user.id }

  before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }
  before { page.driver.header 'Content-Type', 'application/json' }

  let(:controller) { 'statuses' }
  let(:factory)    { 'setting_intensity' }

  describe 'GET /statuses' do

    let!(:resource)  { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }
    let(:uri)        { '/statuses' }

    it_behaves_like 'a listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /statuses/public' do

    let!(:resource)  { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }
    let(:uri)        { '/statuses/public' }

    it_behaves_like 'a public listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /statuses/:id' do

    let!(:resource)  { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :setting_intensity }
    let(:uri)        { "/statuses/#{resource.id}" }

    context 'with a default function' do
      let(:function)  { FactoryGirl.create :function }
      let!(:resource) { FactoryGirl.create :setting_intensity, function: { id: function.id }, resource_owner_id: user.id }
      before { page.driver.get uri }

      it { has_resource resource }
    end

    it_behaves_like 'a showable resource'
    it_behaves_like 'a proxiable resource'
    it_behaves_like 'a crossable resource'
    it_behaves_like 'a public resource', 'page.driver.get(uri)'
    it_behaves_like 'a not found resource', 'page.driver.get(uri)'
  end

  context 'POST /statuses' do

    let(:uri)      { '/statuses' }

    let(:status)     { FactoryGirl.create :status }
    let(:intensity)  { FactoryGirl.create :intensity }
    let(:properties) { [ { id: status.id, values: ['on'] }, { id: intensity.id, ranges: [ { min: '75', max: '100' } ] } ] }
    let(:params)     { { name: 'Setting intensity', properties: properties } }

    before         { page.driver.post uri, params.to_json }
    let(:resource) { Status.last }

    let(:json)     { Hashie::Mash.new JSON.parse(page.source) }

    it 'has two connected properties' do
      json.properties.should have(2).items
    end

    it_behaves_like 'a creatable resource'
    it_behaves_like 'a validated resource', 'page.driver.post(uri, {}.to_json)', { method: 'POST', error: 'can\'t be blank' }
  end

  context 'PUT /statuses/:id' do

    let!(:resource)  { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :setting_intensity }
    let(:uri)        { "/statuses/#{resource.id}" }
    let(:params)     { { name: 'Updated' } }

    it_behaves_like 'an updatable resource'
    it_behaves_like 'a not owned resource', 'page.driver.put(uri)'
    it_behaves_like 'a not found resource', 'page.driver.put(uri)'
    it_behaves_like 'a validated resource', 'page.driver.put(uri, { name: "" }.to_json)', { method: 'PUT', error: 'can\'t be blank' }
  end

  context 'DELETE /statuses/:id' do
    let!(:resource)  { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :setting_intensity }
    let(:uri)        { "/statuses/#{resource.id}" }

    it_behaves_like 'a deletable resource'
    it_behaves_like 'a not owned resource', 'page.driver.delete(uri)'
    it_behaves_like 'a not found resource', 'page.driver.delete(uri)'
  end
end
