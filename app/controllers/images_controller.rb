class ImagesController < ApplicationController
  def create
    image_data = params[:image_data]

    new_file_path = Rails.root.join('public', 'uploads', image_data.original_filename)

    File.open(new_file_path, 'wb') do |file|
      file.write(image_data.read)
    end

    render json: { file_path: new_file_path }
  end
end
