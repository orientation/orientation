require "securerandom"

class ImagesController < ApplicationController
  def create
    image_data = params[:image_data]
    new_file_name = generate_file_name(image_data)
    new_file_path = Rails.root.join('public', 'uploads', new_file_name)

    File.open(new_file_path, 'wb') do |file|
      file.write(image_data.read)
    end

    # the above read means that the file needs to be rewinded before the next
    # read otherwise we'll accidentally read an empty string
    image_data.rewind

    s3 = Aws::S3::Resource.new
    bucket = s3.bucket("orientationtest")
    object = bucket.object(new_file_name)
    object.put(
      acl: "public-read",
      body: image_data.read,
      content_type: image_data.content_type
    )

    render json: { file_path: new_file_path, public_url: object.public_url }
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
