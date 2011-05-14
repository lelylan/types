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
    it "should resizing uploaded image" do
      uploader = ImageUploader.new(Factory(:status), :image)
      uploader.store!(File.open("#{fixture_path}/example.png"))

      uploader.micro.should have_dimensions(16, 16)
      uploader.small.should have_dimensions(32, 32)
      uploader.medium.should have_dimensions(64, 64)
      uploader.big.should have_dimensions(128, 128)
      uploader.huge.should have_dimensions(256, 256)
      uploader.should be_no_larger_than(512, 512)
    end
  end
end
