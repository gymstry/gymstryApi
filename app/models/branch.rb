class Branch < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User,Utility

  default_scope {order("branches.name ASC")}
  scope :order_by_id, -> (ord) {order("branches.id #{ord}")}
  scope :oder_by_name, -> (ord) {order("branches.name #{ord}")}
  scope :order_by_email, -> (ord) {order("branches.email #{ord}")}
  scope :order_by_created_at, -> (ord) {order("branches.created_at #{ord}")}
  scope :search_by_gym_id, -> (id) {where(branches:{gym_id: id})}

  belongs_to :gym, optional: true
  has_many :users, -> {reorder("users.name ASC, users.lastname ASC ")}, dependent: :destroy
  has_many :trainers, -> {reorder("trainers.name ASC, trainers.lastname ASC")}, dependent: :nullify
  has_many :events, -> {reorder("events.class_date ASC")}, dependent: :destroy
  has_many :timetables, dependent: :destroy

  # Horarios en otra tabla
  validates :name, :email, :address, :telephone, presence: true
  validates :name, length: {minimum: 3}
  validates :email, uniqueness: true
  validates_format_of :telephone, :with => /[0-9]{8,10}/x
  validates :address, length: {minimum: 3}

  def self.load_branches(page = 1, per_page = 10)
    includes(:timetables,:events,gym: [:images],users: [:medical_record,:challanges,:workouts,:nutrition_routines],trainers: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.branch_by_id(id)
    includes(:timetables,:events,gym: [:images],users: [:medical_record,:challanges,:workouts,:nutrition_routines],trainers: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .find_by_id(id)
  end

  def self.branch_by_email(email)
    includes(:timetables,:events,gym: [:images],users: [:medical_record,:challanges,:workouts,:nutrition_routines],trainers: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .find_by_email(email)
  end

  def self.branch_by_email_and_gym_id(gym_id,email)
    includes(:timetables,:events,gym: [:images],users: [:medical_record,:challanges,:workouts,:nutrition_routines],trainers: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .find_by_gym_id_and_email(gym_id,email)
  end

  def self.branches_by_name(name,page = 1, per_page = 10)
    load_branches(page,per_page)
      .where("branches.name LIKE ?", "#{name.downcase}%")
  end

  def self.branches_by_name_and_gym_id(gym_id,name,page = 1, per_page = 10)
    branches_by_name(name,page,per_page)
      .search_by_gym_id(gym_id)
  end

  def self.branches_by_gym_id(gym_id,page = 1, per_page = 10)
    load_branches(page, per_page).search_by_gym_id(gym_id)
  end

  def self.branches_by_ids(ids, page = 1, per_page = 10)
    load_branches(page,per_page)
      .where(branches: {id: ids})
  end

  def self.branches_by_not_ids(ids, page = 1, per_page = 10)
    load_branches(page,per_page)
      .where.not(branches: {id: ids})
  end

  def self.branches_with_events(page = 1, per_page = 10)
    joins(:events).select('branches.*')
      .select("COUNT(events.id AS count_events)")
      .group("brances.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(events.id)")
  end

  def self.branches_with_trainers(page = 1, per_page = 10)
    joins(:trainers).select('branches.*')
      .select("COUNT(trainers.id AS count_trainers)")
      .group("branches.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(trainers.id)")
  end

  def self.branches_with_users(page = 1, per_page = 10)
    joins(:users).select('branches.*')
      .select("COUNT(users.id AS count_users)")
      .group("branches.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(users.id)")
  end

  def self.branches_with_timetables(page = 1,per_page = 10)
    joins(:timetables).select("branches.*")
      .group("branches.id")
      .paginate(:page => page,:per_page => per_page)
      .reorder("count(timetables.id)")
  end

  def self.brances_with_events_by_range(type,page = 1, per_page = 10,year = 2017, month = 1)
    branches_with_events_by_date(Branch.new.set_range(type,year,month),page,per_page)
  end

  def self.branches_with_events_by_range_and_gym(gym_id,type,page = 1,per_page = 10, year = 2017, month = 1)
    branches_with_events_by_date_by_gym(gym_id,Branch.new.set_range(type,year,month),page,per_page)
  end

  protected

  def self.branches_with_events_by_date(range,page,per_page)
    load_branches(page,per_page)
      .where(events: {class_date: range})
      .paginate(:page => page, :per_page => per_page)
      .references(:events)
  end

  def self.branches_with_events_by_date_by_gym(gym_id,range,page,per_page)
    load_branches(page,per_page)
      .where(events: {class_date: range})
      .search_by_gym_id(gym_id)
      .paginate(:page => page, :per_page => per_page)
      .references(:events)
  end

end
