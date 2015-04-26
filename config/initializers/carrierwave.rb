CarrierWave.configure do |config|
  if ENV.fetch('S3_BUCKET').present?
    IMAGE_UPLOAD = true

    config.storage  = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('S3_KEY'),
      aws_secret_access_key: ENV.fetch('S3_SECRET'),
      region:                'us-east-1'
    }
    config.fog_directory = ENV.fetch('S3_BUCKET')
  else
    IMAGE_UPLOAD = false
  end
end
