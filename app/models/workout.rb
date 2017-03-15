class Workout < ApplicationRecord

  default_scope {order("workouts.name ASC")}
  scope :order_bu_name, -> (ord) {order("workouts.name #{ord}")}
  scope :order_by_start_date, -> (ord) {order("workouts.start_date #{ord}")}
  scope :order_by_end_date, -> (ord) {order("workouts.end_date #{ord}")}
  scope :order_by_level, -> (ord) {order("workouts.level #{ord}")}
  scope :order_by_create_at, -> (ord) {order("workouts.created_at #{ord}")}
  scope :search_by_user_id, -> (id) {where(workouts:{user_id:id})}
  scope :search_by_trainer_id, -> (id) {where(workouts:{trainer_id:id})}

  belongs_to :user
  belongs_to :trainer
  has_many :workout_per_day, -> {reorder("workout_per_days.name ASC")}, dependent: :destroy

  enum level:{
    :beginner => 0,
    :intermediate => 1,
    :advanced => 2
  }

  validates :name, :start_date, :end_date,:days,:level,presence: true
  validates :name, length: {minimum: 3}
  validates :level, inclusion: {in: levels.keys}
  validates_inclusion_of :days, in: 1..7
  validate :valid_date

  def self.load_workouts(page = 1 ,per_page = 10)
    includes(user: [:medical_record,:challanges,:nutrition_routines],trainer: [:qualifications,:challanges,:nutrition_routines])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.workout_by_id(id)
    includes(user: [:medical_record,:challanges,:nutrition_routines],trainer: [:qualifications,:challanges,:nutrition_routines])
      .find_by_id(id)
  end

  def self.workouts_by_ids(ids,page = 1, per_page = 10)
    load_workouts(page, per_page)
      .where(workouts:{id: ids})
  end

  def self.workouts_by_not_ids(ids, page = 1, per_page = 10)
    load_workouts(page ,per_page)
      .where.not(workouts:{id:ids})
  end

  def self.workouts_by_name(name,page = 1, per_page = 10)
    load_workouts(page, per_page)
      .where("workouts.name LIKE ?","#{name.downcase}%")
  end

  def self.workouts_by_start_date(date,page = 1, per_page = 10)
    load_workouts(page, per_page)
      .where(workouts:{start_date: date})
  end

  def self.workouts_by_start_date_and_user(date,user,page = 1, per_page = 10)
    workouts_by_start_date(date,page,per_page)
      .search_by_user_id(user)
  end

  def self.workouts_by_start_date_and_trainer(date,trainer,page = 1, per_page = 10)
    workouts_by_start_date(date,page,per_page)
      .search_by_trainer_id(trainer)
  end

  def self.workouts_by_start_date_and_user_and_trainer(date,user,trainer,page = 1, per_page = 10)
    workouts_by_start_date(date,page,per_page)
      .search_by_trainer_id(trainer)
      .search_by_user_id(user)
  end

  def self.workouts_by_end_date(date,page = 1, per_page = 10)
    load_workouts(page, per_page)
      .where(workouts:{end_date: date})
  end

  def self.workouts_by_end_date_and_user(date,user,page = 1, per_page = 10)
    workouts_by_end_date(date,page = 1, per_page = 10)
      .search_by_user_id(user)
  end

  def self.workouts_by_end_date_and_trainer(date,trainer,page = 1, per_page = 10 )
    workouts_by_end_date(date,page = 1, per_page = 10)
      .search_by_trainer_id(trainer)
  end

  def self.workouts_by_end_date_and_user_and_trainer(date,user,trainer, page = 1, per_page = 10)
    workouts_by_end_date(date,page = 1, per_page = 10)
      .search_by_trainer_id(trainer)
      .search_by_user_id(user)
  end

  def self.workouts_by_user_id(user,page = 1, per_page = 10)
    load_workouts(page,per_page)
      .search_by_user_id(user)
  end

  def self.workouts_by_trainer_id(trainer,page = 1, per_page = 10)
    load_workouts(page,per_page)
      .search_by_trainer_id(trainer)
  end

  def self.workouts_by_user_and_trainer_id(user,trainer,page = 1, per_page = 10)
    load_workouts(page,per_page)
      .search_by_trainer_id(trainer)
      .search_by_user_id(user)
  end

  def self.workouts_with_workout_per_day(page = 1, per_page = 10)
    joins(:workout_per_day)
      .group("workouts.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(workout_per_day.id)")
  end

  protected
  def valid_date
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end
end
