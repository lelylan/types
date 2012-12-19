require 'spec_helper'

describe StatusProperty do

  it { should_not allow_mass_assignment_of :property_id }
  it { should validate_presence_of :uri }

  it { Settings.uris.valid.each     { |uri| should allow_value(uri).for(:uri) } }
  it { Settings.uris.not_valid.each { |uri| should_not allow_value(uri).for(:uri) } }

  context 'with valid property uris' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { uri: a_uri(status),    matches: ['on'] },
      { uri: a_uri(intensity), matches: ['1..75'] }
    ]}

    let(:resource) { FactoryGirl.create :setting_intensity, properties: properties }

    context 'status property' do

      let(:property) { resource.properties.where(property_id: status.id).first }

      it 'sets the property_id' do
        property.property_id.should == status.id
      end

      it 'sets the value' do
        property.matches.should == ['on']
      end
    end

    context 'intensity property' do

      let(:property) { resource.properties.where(property_id: intensity.id).first }

      it 'sets the property_id' do
        property.property_id.should == intensity.id
      end

      it 'sets the range' do
        property.matches.should == ['1..75']
      end
    end
  end
end
