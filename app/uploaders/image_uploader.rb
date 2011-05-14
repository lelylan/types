class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  # See config/initializers/carrierwave.rb
  # storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/images/devices/default/#{version_name}.png"
  end

  # Original image dimension
  process resize_to_limit: [512, 512]

  # Create different versions of your uploaded files
  version :micro  do process resize_to_limit: [16, 16]   end
  version :small  do process resize_to_limit: [32, 32]   end
  version :medium do process resize_to_limit: [64, 64]   end
  version :big    do process resize_to_limit: [128, 128] end
  version :huge   do process resize_to_limit: [256, 256] end

  # Add a white list of extensions which are allowed to be uploaded
  def extension_white_list
    %w(png)
  end

  # Set the cache dir where to cache uploaded images
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

end
