class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User,Utility
  mount_uploader :avatar, AvatarUploader

  default_scope {order("users.name ASC, users.lastname ASC")}
  scope :order_by_name, -> (ord) {order("users.name #{ord}")}
  scope :order_by_lastname, -> (ord) {order("users.lastname #{ord}")}
  scope :order_by_username, -> (ord) {order("users.username #{ord}")}
  scope :order_by_email, -> (ord) {order("users.email #{ord}")}
  scope :order_by_birthday, -> (ord) {order("users.birthday #{ord}")}
  scope :order_by_gender, -> (ord) {order("users.gender #{ord}")}
  scope :order_by_remaining_days, -> (ord) {order("users.remaining_days #{ord}")}
  scope :search_by_branch_id, -> (id) {where(users:{branch_id:id})}

  belongs_to :branch
  has_one :medical_record, dependent: :destroy
  has_many :challanges, -> {reorder("challanges.start_date ASC")}
  has_many :c_trainers, through: :challanges, source: :trainer
  has_many :measurements, -> {reorder("measurements.created_at ASC")}
  has_many :m_trainers, through: :measurements, source: :trainer
  has_many :nutrition_routines, -> {reorder("nutrition_routines.start_date ASC")}
  has_many :n_trainers, through: :nutrition_routines, source: :trainer
  has_many :workouts, -> {reorder("workouts.start_date")}
  has_many :w_trainers, through: :workouts, source: :trainer

  enum gender: {
    :male => 0,
    :female => 1
  }

  validates :name,:objective,:gender,:lastname,:username,:email,:mobile,:birthday,:remaining_days, presence: true
  validates :username,:email,uniqueness: true
  validates_format_of :mobile, :with => /[0-9]{10,12}/x
  validates :name, :lastname, length: {minimum: 3}
  validates :objective, length: {minimum: 5}
  validates :username, length: {minimum: 5}
  validates :gender, inclusion: {in: genders.keys}
  validates_integrity_of :avatar
  validates_processing_of :avatar
  validates :avatar, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_users(**args)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
    .select(args[:user_params] || "users.*")
    .paginate(:page => args[:page] || 1,:per_page => args[:per_page] || 10)
  end

  def self.load_users_by_branch(branch_id,**args)
    load_users(args)
      .search_by_branch_id(branch_id)
  end

  def self.user_by_id(id)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
    .select(args[:user_params] || "users.*")
    .find_by_id(id)
  end

  def self.users_by_ids(ids, **args)
    load_users(args)
      .where(users: {id: ids})
  end

  def self.users_by_not_ids(ids, **args)
    load_users(args)
      .where.not(users:{id: ids})
  end

  def self.user_by_email(email)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
    .select(args[:user_params] || "users.*").find_by_email(email)
  end

  def self.user_by_username(username)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
      .find_by_username(username)
  end

  def self.users_by_name(name,**args)
    load_users(args)
      .where("users.name LIKE ?","#{name.downcase}%")
  end

  def self.users_by_lastname(lastname, **args)
    load_users(args)
      .where("users.lastname LIKE ?", "#{lastname.downcase}%")
  end

  def self.users_by_username_or_email(text,**args)
    load_users(args)
      .where("users.email LIKE ? or users.username LIKE ?", "#{text.downcase}%", "#{text.downcase}%")
  end

  def self.users_by_birthday(type,**args)
    load_users(page,per_page)
      .where(users:{birthday: User.new.set_range(type,args[:year] || 2017,args[:month] || 1)})
  end

  def self.users_with_challanges(**args)
    joins(:challanges).select("users.*")
      .select("COUNT(challanges.id) AS count_challenges")
      .group("users.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(challanges.id)")
  end

  def self.users_with_measurements(**args)
    joins(:measurements).select("users.*")
      .select("COUNT(measurements.id) AS count_measurements")
      .group("users.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(measurements.id)")
  end

  def self.users_with_nutrition_routines(**args)
    joins(:nutrition_routines).select("users.*")
      .select("COUNT(nutrition_routines.id) AS count_nutrition_routines")
      .group("users.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(nutrition_routines.id)")
  end

  def self.users_with_workouts(**args)
    joins(:workouts).select("users.*")
      .select("COUNT(workouts.id) AS count_workouts")
      .group("users.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(workouts.id)")
  end

end
