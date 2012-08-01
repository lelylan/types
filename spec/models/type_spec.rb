require 'spec_helper'

describe Type do

  it { should_not allow_mass_assignment_of :resource_owner_id }

  it { should validate_presence_of :name }
  it { should validate_presence_of :resource_owner_id }

  it { Settings.uris.valid.each     {|uri| should allow_value(uri).for(:properties)} }
  it { Settings.uris.not_valid.each {|uri| should_not allow_value(uri).for(:properties)} }

  it_behaves_like 'a type connection' do
    let(:property)   { FactoryGirl.create :property }
    let(:connection) { 'properties' }
    let(:uris)       {[ a_uri(property) ]}
    let(:ids)        {[ property.id.to_s ]}
  end

  it_behaves_like 'a type connection' do
    let(:function)   { FactoryGirl.create :function }
    let(:connection) { 'functions' }
    let(:uris)       {[ a_uri(function) ]}
    let(:ids)        {[ function.id.to_s ]}
  end

  it_behaves_like 'a type connection' do
    let(:status)     { FactoryGirl.create :setting_intensity }
    let(:connection) { 'properties' }
    let(:uris)       {[ a_uri(status) ]}
    let(:ids)        {[ status.id.to_s ]}
  end
  
  it_behaves_like 'a type connection' do
    let(:category)   { FactoryGirl.create :category }
    let(:connection) { 'properties' }
    let(:uris)       {[ a_uri(category) ]}
    let(:ids)        {[ category.id.to_s ]}
  end
end
