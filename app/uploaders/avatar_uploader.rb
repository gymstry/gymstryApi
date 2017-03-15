class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog
  process resize_to_fit: [250,250]

  def initialize(*)
    super
    self.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => ENV["RACKSPACE_USERNAME"],
      :rackspace_api_key  => ENV["RACKSPACE_API_KEY"],
      :rackspace_region    => :dfw
    }
    self.fog_directory = 'gymstry_qualification'
  end

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
    process resize_to_fill: [150,150]
  end

  version :gray, from_version: :thumb do
    process :convert_to_grayscale
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [250,250]
  end

  version :gray_small, from_version: :small_thumb do
    process :convert_to_grayscale
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

    def convert_to_grayscale
      manipulate! do |img|
        img.colorspace("Gray")
        img.brightness_contrast("-30x0")
        img = yield(img) if block_given?
        img
      end
    end

end
