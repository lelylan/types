require 'spec_helper'

describe StatusProperty do

  it { should validate_presence_of :uri }

  it { Settings.validation.uris.valid.each     { |uri| should allow_value(uri).for(:uri) } }
  it { Settings.validation.uris.not_valid.each { |uri| should_not allow_value(uri).for(:uri) } }

  context 'with valid property uri' do

    let(:properties) {[
      { uri: 'https://api.lelylan.com/properties/status', pending: false , values: ['on'] },
      { uri: 'https://api.lelylan.com/properties/intensity', pending: true, min_range: '75', max_range: '100' }
    ]}

    let(:status) { FactoryGirl.create :setting_intensity, properties: properties }

    context 'status property' do

      subject { status.properties.where(property_id: 'status').first }

      it 'sets the property_id' do
        subject.property_id.should == 'status'
      end

      it 'sets the value' do
        subject.values.should == ['on']
      end
    end

    context 'intensity property' do

      subject { status.properties.where(property_id: 'intensity').first }

      it 'sets the property_id' do
        subject.property_id.should == 'intensity'
      end

      it 'sets the range' do
        subject.min_range.should == '75'
        subject.max_range.should == '100'
      end
    end
  end
end
