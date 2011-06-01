require 'spec_helper'

describe Status do
  include CarrierWave::Test::Matchers

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:uri) }
  it { should allow_value(Settings.validation.valid_uri).for(:uri) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:uri) }

  it { should validate_presence_of(:created_from) }
  it { should allow_value(Settings.validation.valid_uri).for(:created_from) }
  it { should_not allow_value(Settings.validation.not_valid_uri).for(:created_from) }


  describe "#image" do
    before { ImageUploader.enable_processing = true }
    it "should resizing uploaded image" do
      uploader = ImageUploader.new(Factory(:is_setting_intensity), :image)
      uploader.store!(File.open("#{fixture_path}/example.png"))
      uploader.should be_no_larger_than(Settings.thumbs.original, Settings.thumbs.original)

      uploader.micro.should  have_dimensions(Settings.thumbs.micro, Settings.thumbs.micro)
      uploader.small.should  have_dimensions(Settings.thumbs.small, Settings.thumbs.small)
      uploader.medium.should have_dimensions(Settings.thumbs.medium, Settings.thumbs.medium)
      uploader.big.should    have_dimensions(Settings.thumbs.big, Settings.thumbs.big)
      uploader.large.should  have_dimensions(Settings.thumbs.large, Settings.thumbs.large)
    end
  end

  
  describe "#create_status_properties" do
    context "when valid" do
      before  { @properties = [{ uri: Settings.properties.status.uri, values: %w(on), pending: true }] }
      subject { Factory(:default_status, properties: @properties).status_properties }
      it { should have(1).item }
    end

    context "when not valid" do
      # all params, except URI, which is handled differently, are optionals.
    end

    context "when has duplicated property URI" do
      before do
        @message = "A resource can not be connected more than once"
        @properties = [
          { uri: Settings.properties.status.uri, values: %w(on) },
          { uri: Settings.properties.status.uri, values: %w(off)} ]
      end

      it "should get a not valid notification" do
        lambda{ Factory(:default_status, properties: @properties) }.
          should raise_error(Mongoid::Errors::Duplicated, @message)
      end
    end

    context "with not owned properties" do
    end

    context "with not existng property" do
    end
  end
end
