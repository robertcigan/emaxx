# encoding: utf-8
require 'carrierwave/processing/mime_types'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file
  
  def store_dir
    Rails.env.test? ? "test_uploads/#{model.class.to_s.underscore}/#{model.id}" : "uploads/#{model.class.to_s.underscore}/#{model.id}" 
  end
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  # storage :fog
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  process :resize_to_fit => [1024, 1024]

  version :small do
    process :resize_to_fill => [96,96]
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  process :set_content_type
end
