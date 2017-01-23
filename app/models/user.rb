class User < ActiveRecord::Base
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
  end

  def set_token
    User.new.set_token_resource(self)
  end

  belongs_to :branch

  validates :name,:lastname,:username,:avatar,:email,:mobile,:birthday,:remaining_days, presence: true
  validates :username,:email,uniqueness: true
  validates_format_of :mobile, :with => /[0-9]{10,12}/x
  validates :name, :lastname, length: {minimum: 3}
  validates :username, length: {minimum: 5}

end
