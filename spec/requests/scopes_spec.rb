require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Scope' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  context 'with no token' do

    context 'types controller' do

      let(:resource) { FactoryGirl.create :type, resource_owner_id: user.id }

      it { should authorize "get /types/public" }
      it { should authorize "get /types/#{resource.id}" }

      it { should_not authorize "get /types" }
      it { should_not authorize "post /types" }
      it { should_not authorize "put /types/#{resource.id}" }
      it { should_not authorize "delete /types/#{resource.id}" }
    end

    context 'properties controller' do

      let(:resource) { FactoryGirl.create :property, resource_owner_id: user.id }

      it { should authorize "get /properties/public" }
      it { should authorize "get /properties/#{resource.id}" }

      it { should_not authorize "get /properties" }
      it { should_not authorize "post /properties" }
      it { should_not authorize "put /properties/#{resource.id}" }
      it { should_not authorize "delete /properties/#{resource.id}" }
    end

    context 'functions controller' do

      let(:resource) { FactoryGirl.create :function, resource_owner_id: user.id }

      it { should authorize "get /functions/public" }
      it { should authorize "get /functions/#{resource.id}" }

      it { should_not authorize "get /functions" }
      it { should_not authorize "post /functions" }
      it { should_not authorize "put /functions/#{resource.id}" }
      it { should_not authorize "delete /functions/#{resource.id}" }
    end

    context 'statuses controller' do

      let(:resource) { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }

      it { should authorize "get /statuses/public" }
      it { should authorize "get /statuses/#{resource.id}" }

      it { should_not authorize "get /statuses" }
      it { should_not authorize "post /statuses" }
      it { should_not authorize "put /statuses/#{resource.id}" }
      it { should_not authorize "delete /statuses/#{resource.id}" }
    end

    context 'categories controller' do

      let(:resource) { FactoryGirl.create :category, resource_owner_id: user.id }

      it { should authorize "get /categories/public" }
      it { should authorize "get /categories/#{resource.id}" }

      it { should_not authorize "get /categories" }
      it { should_not authorize "post /categories" }
      it { should_not authorize "put /categories/#{resource.id}" }
      it { should_not authorize "delete /categories/#{resource.id}" }
    end
  end

  context 'with read scope' do

    let!(:scopes)       { 'read' }
    let!(:access_token) { FactoryGirl.create :access_token, scopes: scopes, resource_owner_id: user.id }

    before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }

    context 'types controller' do

      let(:resource) { FactoryGirl.create :type, resource_owner_id: user.id }

      it { should authorize "get /types/public" }
      it { should authorize "get /types/#{resource.id}" }
      it { should authorize "get /types" }

      it { should_not authorize "post /types" }
      it { should_not authorize "put /types/#{resource.id}" }
      it { should_not authorize "delete /types/#{resource.id}" }
    end

    context 'properties controller' do

      let(:resource) { FactoryGirl.create :property, resource_owner_id: user.id }

      it { should authorize "get /properties/public" }
      it { should authorize "get /properties/#{resource.id}" }
      it { should authorize "get /properties" }

      it { should_not authorize "post /properties" }
      it { should_not authorize "put /properties/#{resource.id}" }
      it { should_not authorize "delete /properties/#{resource.id}" }
    end

    context 'functions controller' do

      let(:resource) { FactoryGirl.create :function, resource_owner_id: user.id }

      it { should authorize "get /functions/public" }
      it { should authorize "get /functions/#{resource.id}" }
      it { should authorize "get /functions" }

      it { should_not authorize "post /functions" }
      it { should_not authorize "put /functions/#{resource.id}" }
      it { should_not authorize "delete /functions/#{resource.id}" }
    end

    context 'statuses controller' do

      let(:resource) { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }

      it { should authorize "get /statuses/public" }
      it { should authorize "get /statuses/#{resource.id}" }
      it { should authorize "get /statuses" }

      it { should_not authorize "post /statuses" }
      it { should_not authorize "put /statuses/#{resource.id}" }
      it { should_not authorize "delete /statuses/#{resource.id}" }
    end

    context 'categories controller' do

      let(:resource) { FactoryGirl.create :category, resource_owner_id: user.id }

      it { should authorize "get /categories/public" }
      it { should authorize "get /categories/#{resource.id}" }
      it { should authorize "get /categories" }

      it { should_not authorize "post /categories" }
      it { should_not authorize "put /categories/#{resource.id}" }
      it { should_not authorize "delete /categories/#{resource.id}" }
    end
  end

  context 'with write scope' do

    let!(:scopes)       { 'write' }
    let!(:access_token) { FactoryGirl.create :access_token, scopes: scopes, resource_owner_id: user.id }

    before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }

    context 'types controller' do

      let(:resource) { FactoryGirl.create :type, resource_owner_id: user.id }

      it { should authorize "get /types/public" }
      it { should authorize "get /types/#{resource.id}" }
      it { should authorize "get /types" }
      it { should authorize "post /types" }
      it { should authorize "put /types/#{resource.id}" }
      it { should authorize "delete /types/#{resource.id}" }
    end

    context 'properties controller' do

      let(:resource) { FactoryGirl.create :property, resource_owner_id: user.id }

      it { should authorize "get /properties/public" }
      it { should authorize "get /properties/#{resource.id}" }
      it { should authorize "get /properties" }
      it { should authorize "post /properties" }
      it { should authorize "put /properties/#{resource.id}" }
      it { should authorize "delete /properties/#{resource.id}" }
    end

    context 'functions controller' do

      let(:resource) { FactoryGirl.create :function, resource_owner_id: user.id }

      it { should authorize "get /functions/public" }
      it { should authorize "get /functions/#{resource.id}" }
      it { should authorize "get /functions" }
      it { should authorize "post /functions" }
      it { should authorize "put /functions/#{resource.id}" }
      it { should authorize "delete /functions/#{resource.id}" }
    end

    context 'statuses controller' do

      let(:resource) { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }

      it { should authorize "get /statuses/public" }
      it { should authorize "get /statuses/#{resource.id}" }
      it { should authorize "get /statuses" }
      it { should authorize "post /statuses" }
      it { should authorize "put /statuses/#{resource.id}" }
      it { should authorize "delete /statuses/#{resource.id}" }
    end

    context 'categories controller' do

      let(:resource) { FactoryGirl.create :category, resource_owner_id: user.id }

      it { should authorize "get /categories/public" }
      it { should authorize "get /categories/#{resource.id}" }
      it { should authorize "get /categories" }
      it { should authorize "post /categories" }
      it { should authorize "put /categories/#{resource.id}" }
      it { should authorize "delete /categories/#{resource.id}" }
    end
  end
end
