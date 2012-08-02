shared_examples_for 'a listable resource' do

  it 'shows all owned resources' do
    page.driver.get uri
    page.status_code.should == 200
    eval "contains_owned_#{model} resource"
    eval "does_not_contain_#{model} not_owned"
  end
end

shared_examples_for 'a public listable resource' do

  it 'shows all resources (owned and not owned)' do
    page.driver.get uri
    page.status_code.should == 200
    JSON.parse(page.source).should have(2).items
  end
end

shared_examples_for 'a showable resource' do

  before { page.driver.get uri }

  it 'view the owned resource' do
    page.status_code.should == 200
    eval "has_#{model} resource"
  end
end

shared_examples_for 'a creatable resource' do

  let(:klass)    { controller.classify.constantize }

  it 'creates the resource' do
    page.driver.post uri, params.to_json
    resource = klass.last
    page.status_code.should == 201
    eval "has_#{model} resource"
  end

  it 'stores the resource' do
    expect { page.driver.post(uri, params.to_json) }.to change { klass.count }.by(1)
  end
end

shared_examples_for 'an updatable resource' do

  it 'updates the resource' do
    page.driver.put uri, params.to_json
    resource.reload
    page.status_code.should == 200
    page.should have_content 'Updated'
    eval "has_#{model} resource"
  end
end


shared_examples_for 'a deletable resource' do

  let(:klass)    { controller.classify.constantize }

  it 'deletes the resource' do
    expect { page.driver.delete(uri) }.to change{ klass.count }.by(-1)
    page.status_code.should == 200
    eval "has_#{model} resource"
  end
end
