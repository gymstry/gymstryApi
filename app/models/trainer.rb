class Trainer < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User,Utility
  mount_uploader :avatar, AvatarUploader


  default_scope {order("trainers.name ASC, trainers.lastname ASC")}
  scope :order_by_name, -> (ord) {order("trainers.name #{ord}")}
  scope :order_by_lastname, -> (ord) {order("trainers.lastname #{ord}")}
  scope :order_by_username, -> (ord) {order("trainers.username #{ord}")}
  scope :order_by_email, -> (ord) {order("trainers.email #{ord}")}
  scope :order_by_birthday, -> (ord) {order("trainers.birthday #{ord}")}
  scope :order_by_type_trainer, -> (ord) {order("trainers.type_trainer #{ord}")}
  scope :order_by_created_at, -> (ord) {order("trainers.created_at #{ord}")}
  scope :search_by_branch_id, -> (id) {where(trainers:{branch_id: id})}

  def set_attributes(attribute)
    self.name = attribute.has_key?(:name) ? attribute[:name] : self.name
    self.lastname = attribute.has_key?(:lastname) ? attribute[:lastname] : self.lastname
    self.birthday = attribute.has_key?(:birthday) ? attribute[:birthday] : self.birthday
    self.mobile = attribute.has_key?(:mobile) ? attribute[:mobile] : self.mobile
    self.avatar = attribute.has_key?(:avatar) ? attribute[:avatar] : self.avatar
    self.speciality = attribute.has_key?(:speciality) ? attribute[:speciality].split(",") : self.speciality
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
  has_many :exercises, -> {reorder("exercises.name ASC")}, dependent: :destroy


  validates :name,:lastname,:mobile,:email,:type_trainer,:birthday,:username, presence: true
  validates :name, :lastname, length: {minimum: 3}
  validates :username,:email, uniqueness: true
  validates :username, length: {minimum: 5}
  validates :type_trainer, inclusion: {in: type_trainers.keys}
  validates_format_of :mobile, :with => /[0-9]{10,12}/x
  validates_integrity_of :avatar
  validates_processing_of :avatar
  validates :avatar, file_size: { less_than_or_equal_to: 1.megabyte }
  validate :validate_speciality

  def self.load_trainers(page = 1, per_page = 10)
    includes(:qualifications,challanges: [:user],measurements: [:user],workouts: [:user])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.trainer_by_id(id)
    includes(:qualifications,challanges: [:user],measurements: [:user],workouts: [:user])
      .find_by_id(id)
  end

  def self.trainers_by_ids(ids, page = 1, per_page = 10)
    load_trainers(page,per_page)
      .where(trainers:{id: ids})
  end

  def self.trainers_by_not_ids(ids, page = 1, per_page = 10)
    load_trainers(page, per_page)
      .where.not(trainers:{id: ids})
  end

  def self.trainer_by_username(username)
    includes(:qualifications,challanges: [:user],measurements: [:user],workouts: [:user])
      .find_by_username(username)
  end

  def self.trainer_by_email(email)
    includes(:qualifications,challanges: [:user],measurements: [:user],workouts: [:user])
      .find_by_email(email)
  end

  def self.trainers_by_name(name,page = 1, per_page = 10)
    load_trainers(page,per_page)
      .where("trainers.name LIKE ?", "#{name.downcase}%")
  end

  def self.trainers_by_lastname(lastname,page = 1, per_page = 10)
    load_trainers(page,per_page)
      .where("trainers.lastname LIKE ?", "#{name.downcase}%")
  end

  def self.trainers_by_username_or_email(text,page = 1,per_page = 10)
    load_trainers(page,per_page)
      .where("trainers.email LIKE ? OR trainers.username LIKE ?","#{text.downcase}%", "#{text.downcase}%")
  end

  def self.trainers_by_birthday(type, page = 1, per_page = 10,year = 2017, month = 1)
    load_trainers(page,per_page)
      .where(trainers:{birthday: Trainer.new.set_range(type,year,month)})
  end

  def self.trainers_by_speciality(speciality,page = 1, per_page = 10)
    load_trainers(page,per_page)
    .where("\'#{speciality}\' = ANY (speciality)")
  end

  def self.trainers_with_qualifications(page = 1, per_page = 10)
    joins(:qualifications).select("trainers.*")
      .select("COUNT(qualifications.id) AS count_qualifications")
      .group("trainers.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(qualifications.id)")
  end

  def self.trainers_with_challanges(page = 1, per_page = 10)
    joins(:challanges).select("trainers.*")
      .select("COUNT(challanges.id) AS count_challenges")
      .group("trainers.id")
      .paginate(:page => page,:per_page => per_page)
      .reorder("count(challanges.id)")
  end

  def self.trainers_with_measurements(page = 1, per_page = 10)
    joins(:measurements).select("trainers.*")
      .select("COUNT(measurements.id) AS count_measurements")
      .group("trainers.id")
      .paginate(:page => page,:per_page => per_page)
      .reorder("count(measurements.id)")
  end

  def self.trainers_with_nutrition_routines(page = 1, per_page = 10)
    joins(:nutrition_routines).select("trainers.*")
      .select("COUNT(nutrition_routines.id) AS count_nutrition_routines")
      .group("trainers.id")
      .paginate(:page => page,:per_page => per_page)
      .reorder("count(nutrition_routines.id)")
  end

  def self.trainers_with_workouts(page = 1, per_page = 10)
    joins(:workouts).select("trainers.*")
      .select("COUNT(workouts.id) AS count_workouts")
      .group("trainers.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(workouts.id)")
  end

  protected
  def validate_speciality
    speciality.each do |value|
      errors.add(:speciality,"is not include in the list") unless ["TRX", "crossfit"].include?(value)
    end
  end

end
