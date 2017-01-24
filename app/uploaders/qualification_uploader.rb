class QualificationUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

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
    %w(pdf)
  end

  def content_type_whitelist
    "application/pdf"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end
