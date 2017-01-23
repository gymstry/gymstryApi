class Trainer < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User,Utility

  def set_attributes(attribute)
    self.name = attribute.has_key?(:name) ? attribute[:name] : self.name
    self.lastname = attribute.has_key?(:lastname) ? attribute[:lastname] : self.lastname
    self.birthday = attribute.has_key?(:birthday) ? attribute[:birthday] : self.birthday
    self.mobile = attribute.has_key?(:mobile) ? attribute[:mobile] : self.mobile
    self.avatar = attribute.has_key?(:avatar) ? attribute[:avatar] : self.avatar
    self.speciality = attribute.has_key?(:speciality) ? attribute[:speciality] : self.speciality
  end

  def set_token
    Trainer.new.set_token_resource(self)
  end

  enum type_trainer: {
    :personal_trainer => 0,
    :gym => 1,
    :both => 2
  }

  belongs_to :branch, optional: true
  validates :name,:lastname,:mobile,:email,:speciality,:type_trainer,:avatar,:birthday,:username, presence: true
  validates :name, :lastname, :speciality, length: {minimum: 3}
  validates :username,:email, uniqueness: true
  validates :username, length: {minimum: 5}
  validates :type_trainer, inclusion: {in: type_trainers.keys}
  validates_format_of :mobile, :with => /[0-9]{10,12}/x



end
