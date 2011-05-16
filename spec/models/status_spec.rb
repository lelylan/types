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
      uploader = ImageUploader.new(Factory(:is_setting_intensity), :image)
      uploader.store!(File.open("#{fixture_path}/example.png"))
      uploader.should be_no_larger_than(Settings.thumbs.original, Settings.thumbs.original)

      uploader.micro.should  have_dimensions(Settings.thumbs.micro, Settings.thumbs.micro)
      uploader.small.should  have_dimensions(Settings.thumbs.small, Settings.thumbs.small)
      uploader.medium.should have_dimensions(Settings.thumbs.medium, Settings.thumbs.medium)
      uploader.big.should    have_dimensions(Settings.thumbs.big, Settings.thumbs.big)
      uploader.huge.should   have_dimensions(Settings.thumbs.huge, Settings.thumbs.huge)
    end
  end
end
