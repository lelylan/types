require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Scope' do

  let!(:application) { FactoryGirl.create :application }
  let!(:user)        { FactoryGirl.create :user }

  context 'with no token' do

    let(:type)     { FactoryGirl.create :type, resource_owner_id: user.id }
    let(:property) { FactoryGirl.create :property, resource_owner_id: user.id }
    let(:function) { FactoryGirl.create :function, resource_owner_id: user.id }
    let(:status)   { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }

    it { should authorize "get /types/public" }
    it { should authorize "get /types/#{type.id}" }
    it { should authorize "get /properties/public" }
    it { should authorize "get /properties/#{property.id}" }
    it { should authorize "get /functions/public" }
    it { should authorize "get /functions/#{function.id}" }
    it { should authorize "get /statuses/public" }
    it { should authorize "get /statuses/#{status.id}" }

    it { should_not authorize "get    /types" }
    it { should_not authorize "post   /types" }
    it { should_not authorize "put    /types/#{type.id}" }
    it { should_not authorize "delete /types/#{type.id}" }
    it { should_not authorize "get    /properties" }
    it { should_not authorize "post   /properties" }
    it { should_not authorize "put    /properties/#{property.id}" }
    it { should_not authorize "delete /properties/#{property.id}" }
    it { should_not authorize "get    /functions" }
    it { should_not authorize "post   /functions" }
    it { should_not authorize "put    /functions/#{function.id}" }
    it { should_not authorize "delete /functions/#{function.id}" }
    it { should_not authorize "get    /statuses" }
    it { should_not authorize "post   /statuses" }
    it { should_not authorize "put    /statuses/#{status.id}" }
    it { should_not authorize "delete /statuses/#{status.id}" }
  end

  %w(types-read resources-read).each do |scope|

    context "with token #{scope}" do

      let!(:access_token) { FactoryGirl.create :access_token, scopes: scope, resource_owner_id: user.id }
      before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }

      let(:type)     { FactoryGirl.create :type, resource_owner_id: user.id }
      let(:property) { FactoryGirl.create :property, resource_owner_id: user.id }
      let(:function) { FactoryGirl.create :function, resource_owner_id: user.id }
      let(:status)   { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }

      it { should authorize "get /types/public" }
      it { should authorize "get /types/#{type.id}" }
      it { should authorize "get /types" }
      it { should authorize "get /properties/public" }
      it { should authorize "get /properties/#{property.id}" }
      it { should authorize "get /properties" }
      it { should authorize "get /functions/public" }
      it { should authorize "get /functions/#{function.id}" }
      it { should authorize "get /functions" }
      it { should authorize "get /statuses/public" }
      it { should authorize "get /statuses/#{status.id}" }
      it { should authorize "get /statuses" }

      it { should_not authorize "post   /types" }
      it { should_not authorize "put    /types/#{type.id}" }
      it { should_not authorize "delete /types/#{type.id}" }
      it { should_not authorize "post   /properties" }
      it { should_not authorize "put    /properties/#{property.id}" }
      it { should_not authorize "delete /properties/#{property.id}" }
      it { should_not authorize "post   /functions" }
      it { should_not authorize "put    /functions/#{function.id}" }
      it { should_not authorize "delete /functions/#{function.id}" }
      it { should_not authorize "post   /statuses" }
      it { should_not authorize "put    /statuses/#{status.id}" }
      it { should_not authorize "delete /statuses/#{status.id}" }
    end
  end

  %w(types resources).each do |scope|

    context "with token #{scope}" do

      let!(:access_token) { FactoryGirl.create :access_token, scopes: scope, resource_owner_id: user.id }
      before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }

      let(:type)     { FactoryGirl.create :type, resource_owner_id: user.id }
      let(:property) { FactoryGirl.create :property, resource_owner_id: user.id }
      let(:function) { FactoryGirl.create :function, resource_owner_id: user.id }
      let(:status)   { FactoryGirl.create :setting_intensity, resource_owner_id: user.id }

      it { should authorize "get    /types/public" }
      it { should authorize "get    /types/#{type.id}" }
      it { should authorize "get    /types" }
      it { should authorize "post   /types" }
      it { should authorize "put    /types/#{type.id}" }
      it { should authorize "delete /types/#{type.id}" }

      it { should authorize "get    /properties/public" }
      it { should authorize "get    /properties/#{property.id}" }
      it { should authorize "get    /properties" }
      it { should authorize "post   /properties" }
      it { should authorize "put    /properties/#{property.id}" }
      it { should authorize "delete /properties/#{property.id}" }

      it { should authorize "get    /functions/public" }
      it { should authorize "get    /functions/#{function.id}" }
      it { should authorize "get    /functions" }
      it { should authorize "post   /functions" }
      it { should authorize "put    /functions/#{function.id}" }
      it { should authorize "delete /functions/#{function.id}" }

      it { should authorize "get    /statuses/public" }
      it { should authorize "get    /statuses/#{status.id}" }
      it { should authorize "get    /statuses" }
      it { should authorize "post   /statuses" }
      it { should authorize "put    /statuses/#{status.id}" }
      it { should authorize "delete /statuses/#{status.id}" }
    end
  end
end
