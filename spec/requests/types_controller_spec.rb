require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'TypesController' do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, application: application, scopes: 'resources', resource_owner_id: user.id }

  before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }
  before { page.driver.header 'Content-Type', 'application/json' }

  let(:controller) { 'types' }
  let(:factory)    { 'type' }

  describe 'GET /types' do

    let!(:resource)  { FactoryGirl.create :type, resource_owner_id: user.id }
    let(:uri)        { '/types' }

    it_behaves_like 'a listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }

    context 'when does not show connections' do

      before  { page.driver.get uri }
      subject { page }

      it { should_not have_content 'properties' }
      it { should_not have_content 'functions' }
      it { should_not have_content 'statuses' }
    end
  end

  context 'GET /types/public' do

    let!(:resource)  { FactoryGirl.create :type, resource_owner_id: user.id }
    let(:uri)        { '/types/public' }

    it_behaves_like 'a public listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }

    context 'when does not show connections' do

      before  { page.driver.get uri }
      subject { page }

      it { should_not have_content 'properties' }
      it { should_not have_content 'functions' }
      it { should_not have_content 'statuses' }
    end
  end

  context 'GET /types/:id' do

    let!(:resource)  { FactoryGirl.create :type, resource_owner_id: user.id }
    let(:uri)        { "/types/#{resource.id}" }

    it_behaves_like 'a showable resource'
    it_behaves_like 'a proxiable resource'
    it_behaves_like 'a crossable resource'
    it_behaves_like 'a public resource', 'page.driver.get(uri)'
    it_behaves_like 'a not found resource', 'page.driver.get(uri)'
  end

  context 'POST /types' do

    let(:uri) { '/types' }

    let(:status)            { FactoryGirl.create :status }
    let(:intensity)         { FactoryGirl.create :intensity }
    let(:turn_on)           { FactoryGirl.create :turn_on }
    let(:turn_off)          { FactoryGirl.create :turn_off }
    let(:set_intensity)     { FactoryGirl.create :set_intensity }
    let(:setting_intensity) { FactoryGirl.create :setting_intensity }
    let(:lighting)          { FactoryGirl.create :lighting }

    let!(:properties) { [ a_uri(status), a_uri(intensity) ] }
    let!(:functions)  { [ a_uri(turn_on), a_uri(turn_off), a_uri(set_intensity) ] }
    let!(:statuses)   { [ a_uri(setting_intensity) ] }

    let(:params) {{
      name: 'Dimmer',
      properties: properties,
      functions: functions,
      statuses: statuses,
    }}

    context 'when creates the connections' do

      before     { page.driver.post uri, params.to_json }
      let(:json) { Hashie::Mash.new JSON.parse(page.source) }

      it 'has two connected properties' do
        json.properties.should have(2).items
        json.functions.should  have(3).items
        json.statuses.should   have(1).items
      end
    end

    it_behaves_like 'a creatable resource'
    it_behaves_like 'a validated resource', 'page.driver.post(uri, {}.to_json)', { method: 'POST', error: 'can\'t be blank' }
  end

  context 'PUT /types/:id' do

    let!(:resource) { FactoryGirl.create :type, resource_owner_id: user.id }
    let(:uri)       { "/types/#{resource.id}" }
    let(:params)    { { name: 'Updated' } }

    it_behaves_like 'an updatable resource'
    it_behaves_like 'a not owned resource', 'page.driver.put(uri)'
    it_behaves_like 'a not found resource',  'page.driver.put(uri)'
    it_behaves_like 'a validated resource',  'page.driver.put(uri, { name: "" }.to_json)', { method: 'PUT', error: 'can\'t be blank' }
  end

  context 'DELETE /types/:id' do
    let!(:resource)  { FactoryGirl.create :type, resource_owner_id: user.id }
    let(:uri)        { "/types/#{resource.id}" }

    it_behaves_like 'a deletable resource'
    it_behaves_like 'a not owned resource', 'page.driver.put(uri)'
    it_behaves_like 'a not found resource', 'page.driver.delete(uri)'
  end
end
