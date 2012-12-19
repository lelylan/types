require 'spec_helper'

describe StatusProperty do

  its(:pending) { should_not be_true }

  it { should_not allow_mass_assignment_of :property_id }
  it { should validate_presence_of :uri }

  it { Settings.uris.valid.each     { |uri| should allow_value(uri).for(:uri) } }
  it { Settings.uris.not_valid.each { |uri| should_not allow_value(uri).for(:uri) } }

  context 'with valid property uris' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { uri: a_uri(status),    matches: ['on'] },
      { uri: a_uri(intensity), matches: ['1..75'], pending: true }
    ]}

    let(:resource) { FactoryGirl.create :setting_intensity, properties: properties }

    context 'status property' do

      subject { resource.properties.where(property_id: status.id).first }

      its(:property_id) { should == status.id }
      its(:matches)     { should == ['on'] }
      its(:pending)     { should_not be_true }
    end

    context 'intensity property' do

      subject { resource.properties.where(property_id: intensity.id).first }

      its(:property_id) { should == intensity.id }
      its(:matches)     { should == ['1..75'] }
      its(:pending)     { should be_true }
    end
  end
end
