require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'CategoriesController' do

  let(:controller) { 'categories' }

  describe 'GET /categories' do

    before { page.driver.get '/categories' }

    it 'view the categories list' do
      page.driver.get '/categories'
      save_and_open_page
      page.status_code.should == 200
      json = JSON.parse(page.source) unless json
      json.first['name'].should == 'lights'
      json.last['name'].should  == 'others'
    end
  end
end
