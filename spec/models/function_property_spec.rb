require 'spec_helper'

describe FunctionProperty do
  its(:value) { should == nil }

  it { should_not allow_mass_assignment_of :property_id }
  it { should validate_presence_of :id }

  context 'with valid property ids' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { id: status.id,    value: 'on' },
      { id: intensity.id, value: '0.0' }
    ]}

    let(:resource) { FactoryGirl.create :function, properties: properties }

    context 'status property' do

      let(:property) { resource.properties.where(property_id: status.id).first }

      it 'sets the property_id' do
        property.property_id.should == status.id
      end

      it 'sets the value' do
        property.value.should == 'on'
      end
    end

    context 'intensity proeprty' do

      let(:property) { resource.properties.where(property_id: intensity.id).first }

      it 'sets the property_id' do
        property.property_id.should == intensity.id
      end

      it 'sets the value' do
        property.value.should == '0.0'
      end
    end
  end
end
