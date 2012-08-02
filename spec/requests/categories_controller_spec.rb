require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'CategoriesController' do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, application: application, scopes: 'write', resource_owner_id: user.id }

  before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }
  before { page.driver.header 'Content-Type', 'application/json' }

  let(:model) { 'category' }
  let(:controller) { 'categories' }

  describe 'GET /categories' do

    let!(:resource)  { FactoryGirl.create :category, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :category }
    let(:uri)        { '/categories' }

    it_behaves_like 'a listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /categories/public' do

    let!(:resource)  { FactoryGirl.create :category, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :category, name: 'Not owned' }
    let(:uri)        { '/categories/public' }

    it_behaves_like 'a public listable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
    it_behaves_like 'a paginable resource'
  end

  context 'GET /categories/:id' do

    let!(:resource)  { FactoryGirl.create :category, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :category }
    let(:uri)        { "/categories/#{resource.id}" }

    it_behaves_like 'a showable resource'
    it_behaves_like 'a not found resource', 'page.driver.get(uri)'
    it_behaves_like 'a changeable host'
    it_behaves_like 'a public resource'
  end

  context 'POST /categories' do

    let(:uri)      { '/categories' }
    let(:params)   { { name: 'lighting' } }
    before         { page.driver.post uri, params.to_json }
    let(:resource) { Category.last }

    it_behaves_like 'a creatable resource'
    it_behaves_like 'a validated resource', 'page.driver.post(uri, {}.to_json)', { method: 'POST', error: 'can\'t be blank' }
  end

  context 'PUT /categories/:id' do

    let!(:resource) { FactoryGirl.create :category, resource_owner_id: user.id }
    let(:uri)       { "/categories/#{resource.id}" }
    let(:params)    { {name: 'Updated' } }

    it_behaves_like 'an updatable resource'
    it_behaves_like 'a not found resource',  'page.driver.put(uri)'
    it_behaves_like 'a validated resource',  'page.driver.put(uri, {name: ""}.to_json)', { method: 'PUT', error: 'can\'t be blank' }
  end

  context 'DELETE /categories/:id' do
    let!(:resource)  { FactoryGirl.create :category, resource_owner_id: user.id }
    let!(:not_owned) { FactoryGirl.create :category }
    let(:uri)        { "/categories/#{resource.id}" }

    it_behaves_like 'a deletable resource'
    it_behaves_like 'a not found resource', 'page.driver.delete(uri)'
  end
end
