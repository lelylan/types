require 'spec_helper'

describe FunctionProperty do

  it { should_not allow_mass_assignment_of :property_id }

  it { should allow_value(nil).for('value') }

  it { Settings.validation.uris.valid.each     {|uri| should allow_value(uri).for(:uri)} }
  it { Settings.validation.uris.not_valid.each {|uri| should_not allow_value(uri).for(:uri)} }

  context 'with valid property uris' do

    let(:properties) {[
      { uri: 'https://api.lelylan.com/properties/status',    value: 'on' },
      { uri: 'https://api.lelylan.com/properties/intensity', value: '0.0' }
    ]}

    let(:function) { FactoryGirl.create(:function, properties: properties) }

    context 'status property' do

      subject { function.properties.where(property_id: 'status').first }

      it 'sets the property_id' do
        pp function.properties
        subject.property_id.should == 'status'
      end

      it 'sets the value' do
        subject.value.should == 'on'
      end
    end

    context 'intensity proeprty' do

      subject { function.properties.where(property_id: 'intensity').first }

      it 'sets the property_id' do
        subject.property_id.should == 'intensity'
      end

      it 'sets the value' do
        subject.value.should == '0.0'
      end
    end
  end
end
