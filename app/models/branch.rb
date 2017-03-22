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
  has_many :users, -> {reorder("users.name ASC, users.lastname ASC ")}
  has_many :trainers, -> {reorder("trainers.name ASC, trainers.lastname ASC")}
  has_many :events, -> {reorder("events.class_date ASC")}
  has_many :timetables

  # Horarios en otra tabla
  validates :name, :email, :address, :telephone, presence: true
  validates :name, length: {minimum: 3}
  validates :email, uniqueness: true
  validates_format_of :telephone, :with => /[0-9]{8,10}/x
  validates :address, length: {minimum: 3}

  def self.load_branches(**args)
    includes(:timetables,:events,gym: [:images],users: [:medical_record,:challanges,:workouts,:nutrition_routines],trainers: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page])
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

  def self.branches_by_name(name,**args)
    load_branches(args)
      .where("branches.name LIKE ?", "#{name.downcase}%")
  end

  def self.branches_by_name_and_gym_id(gym_id,**args)
    branches_by_name(args[:name],{page: args[:page],per_page: args[:per_page]})
      .search_by_gym_id(gym_id)
  end

  def self.branches_by_gym_id(gym_id,**args)
    load_branches(args).search_by_gym_id(gym_id)
  end

  def self.branches_by_ids(ids, **args)
    load_branches(args)
      .where(branches: {id: ids})
  end

  def self.branches_by_not_ids(ids, **args)
    load_branches(args)
      .where.not(branches: {id: ids})
  end

  def self.branches_with_events(**args)
    joins(:events).select('branches.*')
      .select("COUNT(events.id AS count_events)")
      .group("brances.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(events.id)")
  end

  def self.branches_with_trainers(**args)
    joins(:trainers).select('branches.*')
      .select("COUNT(trainers.id AS count_trainers)")
      .group("branches.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(trainers.id)")
  end

  def self.branches_with_users(**args)
    joins(:users).select('branches.*')
      .select("COUNT(users.id AS count_users)")
      .group("branches.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(users.id)")
  end

  def self.branches_with_timetables(**args)
    joins(:timetables).select("branches.*")
      .group("branches.id")
      .paginate(:page => args[:page] || 1,:per_page => args[:per_page] || 10)
      .reorder("count(timetables.id)")
  end

  def self.brances_with_events_by_range(type,**args)
    branches_with_events_by_date(Branch.new.set_range(type,args[:year] || 2017,args[:month] || 1),{page: args[:page],per_page: args[:per_page]})
  end

  def self.branches_with_events_by_range_and_gym(gym_id,**args)
    branches_with_events_by_date_by_gym(gym_id,{range: Branch.new.set_range(args[:type],args[:year] || 2017,args[:month] || 1),page: args[:page],per_page: args[:per_page]})
  end

  protected

  def self.branches_with_events_by_date(range,**args)
    load_branches(args)
      .where(events: {class_date: range})
      .paginate(:page => page, :per_page => per_page)
      .references(:events)
  end

  def self.branches_with_events_by_date_by_gym(gym_id,**args)
    load_branches({page: args[:page],per_page: args[:per_page]})
      .where(events: {class_date: args[:range]})
      .search_by_gym_id(gym_id)
      .paginate(:page => page, :per_page => per_page)
      .references(:events)
  end

end
