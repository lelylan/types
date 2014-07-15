require 'spec_helper'
require 'sidekiq/testing/inline'

describe Type do

  it { should_not allow_mass_assignment_of :resource_owner_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  it 'accepts valid category' do
    expect{ FactoryGirl.create(:type, category: 'lights') }.to_not raise_error
  end

  it 'does not accept invalid category' do
    expect{ FactoryGirl.create(:type, category: 'not-defined') }.to raise_error
  end

  it_behaves_like 'a type connection' do
    let(:property)   { FactoryGirl.create :property }
    let(:connection) { 'properties' }
    let(:ids)        {[ property.id ]}
  end

  it_behaves_like 'a type connection' do
    let(:function)   { FactoryGirl.create :function }
    let(:connection) { 'functions' }
    let(:ids)        {[ function.id ]}
  end

  it_behaves_like 'a type connection' do
    let(:status)     { FactoryGirl.create :setting_intensity }
    let(:connection) { 'properties' }
    let(:ids)        {[ status.id ]}
  end
end
