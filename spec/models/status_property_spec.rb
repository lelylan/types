require 'spec_helper'

describe StatusProperty do

  its(:pending) { should_not be_true }

  it { should_not allow_mass_assignment_of :property_id }
  it { should validate_presence_of :id }

  context 'with valid property IDs' do

    let(:status)    { FactoryGirl.create :status }
    let(:intensity) { FactoryGirl.create :intensity }

    let(:properties) {[
      { id: status.id, values: [ 'on' ] },
      { id: intensity.id, ranges: [ { min: '1', max: '75' } ], pending: true }
    ]}

    let(:resource) { FactoryGirl.create :setting_intensity, properties: properties }

    context 'status property' do

      subject { resource.properties.where(property_id: status.id).first }

      its(:property_id) { should == status.id }
      its(:values)      { should == ['on'] }
      its(:pending)     { should_not be_true }
    end

    context 'intensity property' do

      subject { resource.properties.where(property_id: intensity.id).first }

      its(:property_id) { should == intensity.id }
      its(:ranges)      { should == [ { min: '1', max: '75' } ] }
      its(:pending)     { should be_true }
    end
  end
end
