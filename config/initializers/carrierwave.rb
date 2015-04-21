CarrierWave.configure do |config|
  # if Rails.env.production?
    config.storage  = :fog

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('S3_KEY'),
      aws_secret_access_key: ENV.fetch('S3_SECRET'),
      region:                'us-east-1'
    }
    config.fog_directory = ENV.fetch('S3_BUCKET')
  # elsif
  #   Fog.mock!
  #   config.storage = :fog
  #
  #   connection = Fog::Storage.new(
  #     aws_access_key_id: 'xx',
  #     aws_secret_access_key: 'yy',
  #     provider: 'AWS',
  #     region: 'us-east-1'
  #   )
  #
  #   connection.directories.create(key: 'test')
  #
  #   config.fog_credentials = {
  #     provider: 'AWS',
  #     aws_access_key_id: 'xx',
  #     aws_secret_access_key: 'yy',
  #     region: 'us-east-1'
  #   }
  #
  #   config.fog_directory = 'test'
  #   config.enable_processing = false
  #
  # else
  #   config.storage = :file
  # end
end
