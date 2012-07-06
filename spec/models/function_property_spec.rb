require 'spec_helper'

describe FunctionProperty do
  
  it { should validate_presence_of(:property_id) }

  context "with duplicated property_id" do

    let(:function_property) { { property_id: 'intensity', value: '0.0' } }
    let(:function)          { FactoryGirl.create(:function_no_connections) }
    before  { function.function_properties.create!(function_property) }
    subject { function.function_properties }

    it "validates the uniqueness of property_id" do
      expect { subject.create!(function_property) }.to raise_error(Mongoid::Errors::Validations)
    end
  end
end
