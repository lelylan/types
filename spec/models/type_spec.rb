require 'spec_helper'

describe Type do
  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:uri) }
  it { should allow_value(Settings.validation.valid_uri).for(:uri) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:uri) }

  it { should validate_presence_of(:created_from) }
  it { should allow_value(Settings.validation.valid_uri).for(:created_from) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:created_from) }

  
  describe "#type_statuses" do
    before { @type = Factory(:type) }
    it "create a default status" do
      default = Settings.status.default_order
      status = Type.where('type_statuses.order' => default).first
      status.should_not be_nil 
    end
    it "create an ordered statuses list" do
    end
    it "do not change with empty statuses Array" do
    end
    it "raise error with not Array statuses" do
    end
    context "when updated" do
      it "leave default status" do
      end
      it "destroy previous stauses" do
      end
      it "creates a new ordered statuses list" do
      end
    end
  end
end
