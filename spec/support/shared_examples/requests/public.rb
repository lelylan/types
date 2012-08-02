shared_examples_for 'a public resource' do |action|

  let!(:not_owned) { FactoryGirl.create :function }
  let(:uri)        { "/#{controller}/#{not_owned.id}" }

  it 'does not create a resource' do
    eval action
    page.status_code.should == 200
  end
end
