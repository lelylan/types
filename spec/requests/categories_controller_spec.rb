require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'CategoriesController' do

  let(:controller) { 'categories' }

  describe 'GET /categories' do

    before { page.driver.get '/categories' }

    it 'view the categories list' do
      page.driver.get '/categories'
      page.status_code.should == 200
      json = JSON.parse(page.source) unless json

      json.first['tag'].should == 'lights'
      json.first['name'].should == 'Lights'
      json.last['tag'].should  == 'others'
      json.last['name'].should  == 'Other categories'
    end
  end
end
