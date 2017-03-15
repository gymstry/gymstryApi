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

  enum gender: {
    :male => 0,
    :female => 1
  }

  belongs_to :branch
  has_one :medical_record, dependent: :destroy
  has_many :challanges, -> {reorder("challanges.start_date ASC")}, dependent: :destroy
  has_many :c_trainers, through: :challanges, source: :trainer
  has_many :measurements, -> {reorder("measurements.created_at ASC")}, dependent: :destroy
  has_many :m_trainers, through: :measurements, source: :trainer
  has_many :nutrition_routines, -> {reorder("nutrition_routines.start_date ASC")}, dependent: :destroy
  has_many :n_trainers, through: :nutrition_routines, source: :trainer
  has_many :workouts, -> {reorder("workouts.start_date")}, dependent: :destroy
  has_many :w_trainers, through: :workouts, source: :trainer

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

  def self.load_users(page = 1,per_page = 10)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
      .paginate(:page => page,:per_page => per_page)
  end

  def self.load_users_by_branch(branch_id,page = 1,per_page = 10)
    load_users(page,per_page)
      .search_by_branch_id(branch_id)
  end

  def self.user_by_id(id)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
      .find_by_id(id)
  end

  def self.users_by_ids(ids, page = 1, per_page = 10)
    load_users(page,per_page)
      .where(users: {id: ids})
  end

  def self.users_by_not_ids(ids, page = 1, per_page = 10)
    load_users(page,per_page)
      .where.not(users:{id: ids})
  end

  def self.user_by_email(email)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
      .find_by_email(email)
  end

  def self.user_by_username(username)
    includes(:medical_record,challanges: [:trainer],measurements: [:trainer],workouts: [:trainer])
      .find_by_username(username)
  end

  def self.users_by_name(name,page = 1, per_page = 10)
    load_users(page,per_page)
      .where("users.name LIKE ?","#{name.downcase}%")
  end

  def self.users_by_lastname(lastname, page = 1, per_page = 10)
    load_users(page,per_page)
      .where("users.lastname LIKE ?", "#{lastname.downcase}%")
  end

  def self.users_by_username_or_email(text,page = 1, per_page = 10)
    load_users(page,per_page)
      .where("users.email LIKE ? or users.username LIKE ?", "#{text.downcase}%", "#{text.downcase}%")
  end

  def self.users_by_birthday(type,page = 1, per_page = 10, year = 2017, month = 1)
    load_users(page,per_page)
      .where(users:{birthday: User.new.set_range(type,year,month)})
  end

  def self.users_with_challanges(page = 1, per_page = 10)
    joins(:challanges).select("users.*")
      .select("COUNT(challanges.id) AS count_challenges")
      .group("users.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(challanges.id)")
  end

  def self.users_with_measurements(page = 1, per_page = 10)
    joins(:measurements).select("users.*")
      .select("COUNT(measurements.id) AS count_measurements")
      .group("users.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(measurements.id)")
  end

  def self.users_with_nutrition_routines(page = 1, per_page = 10)
    joins(:nutrition_routines).select("users.*")
      .select("COUNT(nutrition_routines.id) AS count_nutrition_routines")
      .group("users.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(nutrition_routines.id)")
  end

  def self.users_with_workouts(page = 1, per_page = 10)
    joins(:workouts).select("users.*")
      .select("COUNT(workouts.id) AS count_workouts")
      .group("users.id")
      .paginate(:page => page,:per_page =>per_page)
      .reorder("count(workouts.id)")
  end

end
