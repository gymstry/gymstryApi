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

  enum gender: {
    :male => 0,
    :female => 1
  }

  belongs_to :branch
  has_one :medical_record
  has_many :challanges, -> {reorder("challanges.start_date ASC")}, dependent: :destroy
  has_many :c_trainers, through: :challanges, source: :trainer
  has_many :measurements, -> {reorder("measurements.created_at ASC")}, dependent: :destroy
  has_many :m_trainers, through: :measurements, source: :trainer
  has_many :nutrition_routines, -> {reorder("nutrition_routines.start_date ASC")}, dependent: :destroy
  has_many :n_trainers, through: :nutrition_routines, source: :trainer
  has_many :workouts, -> {reorder("workouts.start_date")}, dependent: :destroy
  has_many :w_trainers, through: :workouts, source: :trainer

  validates :name,:objective,:gender,:lastname,:username,:avatar,:email,:mobile,:birthday,:remaining_days, presence: true
  validates :username,:email,uniqueness: true
  validates_format_of :mobile, :with => /[0-9]{10,12}/x
  validates :name, :lastname, length: {minimum: 3}
  validates :objective, length: {minimum: 5}
  validates :username, length: {minimum: 5}
  validates :gender, inclusion: {in: genders.keys}


end
