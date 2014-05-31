if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['S3_ACCESS_KEY_ID'],                        # required
    :aws_secret_access_key  => ENV['S3_SECRET_ACCESS_KEY'],                        # required
    :region                 => 'us-east-1'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'codeschool'                     # required
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  config.storage = :fog
end
