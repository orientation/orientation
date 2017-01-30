require "securerandom"

class ImagesController < ApplicationController
  def create
    image_data = params[:image_data]
    new_file_name = generate_file_name(image_data)
    
    if Rails.configuration.orientation["upload"] == :localhost
      file = Rails.root.join('public', 'uploads', new_file_name)

      File.open(file, 'wb') do |file|
        file.write(image_data.read)
      end

      new_file_path = file.to_path.split("/public/").last


    elsif Rails.configuration.orientation["upload"] == :s3
      s3 = Aws::S3::Resource.new
      bucket = s3.bucket("orientationtest")
      object = bucket.object(new_file_name)
      object.put(
        acl: "public-read",
        body: image_data.read,
        content_type: image_data.content_type
      )

      new_file_path = object.public_url
    else
      raise NotImplementedError("upload not configured in config/orientation.yml")
    end

    render json: { file_url: new_file_path }
  end

  private

  def generate_file_name(image_data)
    begin
      if image_data.original_filename == "blob"
        "#{SecureRandom.hex(16)}.#{extension(image_data.content_type)}"
      else
        image_data.original_filename
      end
    end
  end

  def extension(content_type)
    content_type.split("/").last
  end
end
