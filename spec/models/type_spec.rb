require 'spec_helper'

describe Type do
  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:uri) }
  it { should allow_value(Settings.validation.valid_uri).for(:uri) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:uri) }

  it { should validate_presence_of(:created_from) }
  it { should allow_value(Settings.validation.valid_uri).for(:created_from) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:created_from) }


  describe "#connected_properties" do
    before { @type = Factory(:type) }
    before { @status = Factory(:property_status) }
    before { @intensity = Factory(:property_intensity) }
    it "get all connected properties" do
      @properties = @type.connected_properties
      @properties.should include @status
      @properties.should include @intensity
    end
  end

  describe "#connected_functions" do
    before { @type = Factory(:type) }
    before { @set_intensity = Factory(:set_intensity) }
    before { @turn_on = Factory(:turn_on) }
    before { @turn_off = Factory(:turn_off) }
    it "get all connected functions" do
      @functions = @type.connected_functions
      @functions.should include @set_intensity
      @functions.should include @turn_on
      @functions.should include @turn_off
    end
  end

  describe "#connected_statuses" do
    before { @type = Factory(:type) }
    before { @is_setting_intensity = Factory(:is_setting_intensity) }
    before { @has_set_intensity = Factory(:has_set_intensity) }
    before { @is_setting_max = Factory(:is_setting_max) }
    before { @has_set_max = Factory(:has_set_max) }
    it "get all connected statuses without default" do
      @statuses = @type.connected_statuses
      @statuses.should include @is_setting_intensity
      @statuses.should include @has_set_intensity
      @statuses.should include @is_setting_max
      @statuses.should include @has_set_max
    end
  end

  describe "#statuses_uri" do
    before { @type = Factory(:type) }

    context "with no default status" do
      subject { @type.statuses_uri }
      it { should have(4).connections }
      it { should_not include Settings.statuses.default.uri }
    end

    context "with default status" do
      subject { @type.statuses_uri(true) }
      it { should have(5).connections }
      it { should include Settings.statuses.default.uri }
    end
  end

  
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

        context "with not valid statuses" do
          it "should raise and exception" do
            lambda{
              Factory(:type, statuses: {})
            }.should raise_error(Mongoid::Errors::InvalidType)
          end
        end
      end
    end

    context "when #updating" do

      context "with different order" do
        before do
          @type.update_attributes(statuses:[
            Settings.statuses.has_set_intensity.uri,
            Settings.statuses.is_setting_intensity.uri,
            Settings.statuses.has_set_max.uri,
            Settings.statuses.is_setting_max.uri ])
        end
        describe "#first element" do
          subject { @type_statuses.first }
          its(:uri) { should == Settings.statuses.has_set_intensity.uri }
          its(:order) { should == 1 }
        end
      end

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

      context "with not valid statuses" do
        it "should raise and exception" do
          lambda{
            @type.update_attributes(statuses: {})
          }.should raise_error(Mongoid::Errors::InvalidType)
        end
      end  
    end
  end
end
