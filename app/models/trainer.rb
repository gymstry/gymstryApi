class Trainer < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User,Utility

  default_scope {order("trainers.name ASC, trainers.lastname ASC")}

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
  }

  # If the trainer is a personal trainer we must create another end point where this trainer can create a branch because our logic is around the branch table

  belongs_to :branch, optional: true
  has_many :qualifications, -> {reorder("qualifications.created_at ASC")}, dependent: :destroy
  has_many :challanges, -> {reorder("challanges.start_date ASC")}, dependent: :nullify
  has_many :c_users, through: :challanges, source: :user
  has_many :measurements,-> {reorder("measurements.created_at ASC")}, dependent: :nullify
  has_many :m_users, through: :measurements, source: :user
  has_many :nutrition_routines, ->{reorder("nutrition_routines.start_date ASC")}, dependent: :nullify
  has_many :n_users, through: :nutrition_routines, source: :user
  has_many :workouts, -> {reorder("workouts.start_date  ASC")}, dependent: :nullify
  has_many :w_users, through: :workouts, source: :user


  validates :name,:lastname,:mobile,:email,:speciality,:type_trainer,:avatar,:birthday,:username, presence: true
  validates :name, :lastname, :speciality, length: {minimum: 3}
  validates :username,:email, uniqueness: true
  validates :username, length: {minimum: 5}
  validates :type_trainer, inclusion: {in: type_trainers.keys}
  validates_format_of :mobile, :with => /[0-9]{10,12}/x



end
