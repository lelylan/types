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
    before { @type_statuses = @type.type_statuses.asc(:order) }
    before { @default_order = Settings.statuses.default_order }

    context "when creating" do
      it { @type_statuses.should have(5).connections }

      context "with ordered list" do
        describe "#first element" do
          subject { @type_statuses.first }
          its(:uri) { should == Settings.statuses.is_setting_max.uri }
          its(:order) { should == 1 }
        end

        describe "#last element" do
          subject { @type_statuses.last }
          its(:uri) { should == Settings.statuses.default.uri }
          its(:order) { should == @default_order }
        end
      end

      context "with no statuses" do
        context "when nil" do
          before { @type = Factory(:type, statuses: nil) }
          it "should contain only default status" do
            @type.type_statuses.should have(1).connection
          end
        end
        
        context "when empty" do
          before { @type = Factory(:type, statuses: []) }
          it "should contain only default status" do
            @type.type_statuses.should have(1).connection
          end
        end
      end
    end

    context "when #updating" do
      context "with nil statuses" do
        before { @type.update_attributes(statuses: nil) }
        it "should not delete previous stautses" do
          @type.type_statuses.should have(5).connection
        end
      end

      context "with empty statuses" do
        before { @type.update_attributes(statuses: []) }
        it "should contain only default status" do
          @type.type_statuses.should have(1).connection
        end
      end
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
