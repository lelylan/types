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
    "uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/images/devices/default/#{version_name}.png"
  end

  # Original image dimension
  process resize_to_limit: [Settings.thumbs.original, Settings.thumbs.original]

  # Create different versions of your uploaded files
  version :micro do 
    size = Settings.thumbs.micro
    process resize_to_limit: [size, size] 
  end

  version :small do 
    size = Settings.thumbs.small
    process resize_to_limit: [size, size] 
  end

  version :medium do 
    size = Settings.thumbs.medium
    process resize_to_limit: [size, size] 
  end

  version :big do 
    size = Settings.thumbs.big
    process resize_to_limit: [size, size] 
  end

  version :huge do 
    size = Settings.thumbs.huge
    process resize_to_limit: [size, size] 
  end

  # Add a white list of extensions which are allowed to be uploaded
  def extension_white_list
    %w(png)
  end

  # Set the cache dir where to cache uploaded images
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

end
