CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'xxx',
      :aws_secret_access_key  => 'yyy',
      :region                 => 'us-east-1'
    }
    config.fog_directory  = 'name_of_bucket'
    config.fog_host       = 'https://assets.example.com'
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  else
    config.storage = :file
  end
end

