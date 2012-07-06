require 'spec_helper'

describe StatusProperty do

  it { should validate_presence_of(:property_id) }
  it { ['true', 'false', nil].each { |value| should allow_value(value).for(:pending) } }
  it { ['not_valid', ''].each { |value| should_not allow_value(value).for(:pending) } }

  context "with duplicated property_id" do

    let(:status_property) { { property_id: 'intensity', range_start: '0', range_end: '100', pending: 'true' } }
    let(:status)          { FactoryGirl.create(:status_no_connections) }
    before  { status.status_properties.create!(status_property) }
    subject { status.status_properties }

    it "validates the uniqueness of property_id" do
      expect { subject.create!(status_property) }.to raise_error(Mongoid::Errors::Validations)
    end
  end
end
