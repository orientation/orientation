CarrierWave.configure do |config|
  IMAGE_UPLOAD = false
  begin
    config.storage  = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('S3_KEY'),
      aws_secret_access_key: ENV.fetch('S3_SECRET'),
      region:                'us-east-1'
    }
    config.fog_directory = ENV.fetch('S3_BUCKET')
    IMAGE_UPLOAD = true
  rescue KeyError
  end
end
