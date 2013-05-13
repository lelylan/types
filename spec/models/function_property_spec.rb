require 'spec_helper'

describe FunctionProperty do
  its(:expected) { should == nil }

  it { should_not allow_mass_assignment_of :property_id }
  it { should validate_presence_of :id }

  context 'with valid property ids' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { id: status.id,    expected: 'on' },
      { id: intensity.id, expected: '0.0' }
    ]}

    let(:resource) { FactoryGirl.create :function, properties: properties }

    context 'status property' do

      let(:property) { resource.properties.where(property_id: status.id).first }

      it 'sets the property_id' do
        property.property_id.should == status.id
      end

      it 'sets #expected' do
        property.expected.should == 'on'
      end
    end

    context 'intensity proeprty' do

      let(:property) { resource.properties.where(property_id: intensity.id).first }

      it 'sets the property_id' do
        property.property_id.should == intensity.id
      end

      it 'sets #expected' do
        property.expected.should == '0.0'
      end
    end
  end
end
