require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'CategoriesController' do

  let(:controller) { 'categories' }

  describe 'GET /categories' do

    before { page.driver.get '/categories' }

    it 'view the categories list' do
      page.driver.get '/categories'
      page.status_code.should == 200
      json = JSON.parse(page.source)
      json.first.should == 'lights'
      json.last.should  == 'others'
    end
  end
end
