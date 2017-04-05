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

  belongs_to :branch, optional: true
  has_many :qualifications, -> {reorder("qualifications.created_at ASC")}
  has_many :challanges, -> {reorder("challanges.start_date ASC")}
  has_many :c_users, through: :challanges, source: :user
  has_many :measurements,-> {reorder("measurements.created_at ASC")}
  has_many :m_users, through: :measurements, source: :user
  has_many :nutrition_routines, ->{reorder("nutrition_routines.start_date ASC")}
  has_many :n_users, through: :nutrition_routines, source: :user
  has_many :workouts, -> {reorder("workouts.start_date  ASC")}
  has_many :w_users, through: :workouts, source: :user
  has_many :exercises, -> {reorder("exercises.name ASC")}

  # If the trainer is a personal trainer we must create another end point where this trainer can create a branch because our logic is around the branch table
  enum type_trainer: {
    :personal_trainer => 0,
    :gym => 1,
  }

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

  def self.load_trainers(**args)
    params = (args[:trainer_params] || "trainers.*") + ","
    params = params + "trainers.id,trainers.branch_id"
    includes(:exercises,:qualifications,challanges: [:user],measurements: [:user],workouts: [:user])
    .select(params)
    .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.trainer_by_id(id,**args)
    params = (args[:trainer_params] || "trainers.*") + ","
    params = params + "trainers.id,trainers.branch_id,trainers.updated_at"
    includes(:exercises,:qualifications,challanges: [:user],measurements: [:user],workouts: [:user])
    .select(params)
    .find_by_id(id)
  end

  def self.trainers_by_ids(ids, **args)
    load_trainers(args)
      .where(trainers:{id: ids})
  end

  def self.trainers_by_not_ids(ids, **args)
    load_trainers(args)
      .where.not(trainers:{id: ids})
  end

  def self.trainers_by_search(search,**args)
    load_trainers(args)
      .where("trainers.name LIKE ? or trainers.lastname LIKE ? or trainers.email LIKE ? or trainers.username LIKE ?","#{search}%","#{search}%","#{search}%","#{search}%")
  end

  def self.trainers_by_birthday(type, **args)
    load_trainers({page: args[:page],per_page: args[:per_page]})
      .where(trainers:{birthday: Trainer.new.set_range(type || "today",args[:year] || Date.today.year,args[:month] || 1)})
  end

  def self.trainers_by_speciality(speciality,**args)
    load_trainers(**args)
    .where("\'#{speciality || ""}\' = ANY (speciality)")
  end

  def self.trainers_with_qualifications(**args)
    joins(:qualifications).select(args[:trainer_params] || "trainers.*")
      .select("COUNT(qualifications.id) AS count_qualifications")
      .group("trainers.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(qualifications.id)")
  end

  def self.trainers_with_challanges(**args)
    joins(:challanges).select(args[:trainer_params] || "trainers.*")
      .select("COUNT(challanges.id) AS count_challenges")
      .group("trainers.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(challanges.id)")
  end

  def self.trainers_with_measurements(**args)
    joins(:measurements).select(args[:trainer_params] || "trainers.*")
      .select("COUNT(measurements.id) AS count_measurements")
      .group("trainers.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(measurements.id)")
  end

  def self.trainers_with_nutrition_routines(**args)
    joins(:nutrition_routines).select(args[:trainer_params] || "trainers.*")
      .select("COUNT(nutrition_routines.id) AS count_nutrition_routines")
      .group("trainers.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(nutrition_routines.id)")
  end

  def self.trainers_with_workouts(**args)
    joins(:workouts).select(args[:trainer_params] || "trainers.*")
      .select("COUNT(workouts.id) AS count_workouts")
      .group("trainers.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(workouts.id)")
  end

  protected
  def validate_speciality
    speciality.each do |value|
      errors.add(:speciality,"is not include in the list") unless ["TRX", "crossfit"].include?(value)
    end
  end

end
