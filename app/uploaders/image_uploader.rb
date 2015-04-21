# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "wiki/images"
  end

  def filename
    original_filename.gsub(/^.*\./, "#{Time.now.to_i}.")
  end
end
