class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog
  process :validate_dimensions
  process resize_to_fit: [1000,1000]

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

  def content_type_blacklist
    ['application/text', 'application/json', 'application/pdf']
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  version :thumb do
    process resize_to_fill: [500,500]
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [250,250]
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end
