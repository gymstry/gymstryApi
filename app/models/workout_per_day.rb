class WorkoutPerDay < ApplicationRecord

  default_scope {order("workout_per_days.name ASC")}
  scope :order_by_name, -> (ord) {order("workout_per_days.name #{ord}")}
  scope :order_by_series, -> (ord) {order("workout_per_days.series #{ord}")}
  scope :order_by_repetiton, -> (ord) {order("workout_per_days.repetition #{ord}")}
  scope :order_by_time, -> (ord) {order("workout_per_days.time #{ord}")}
  scope :order_by_rest, -> (ord) {order("workout_per_days.rest #{ord}")}
  scope :order_by_create_at, -> (ord) {order("workout_per_days.created_at #{ord}")}
  scope :search_by_workout_id, -> (id) {where(workout_per_days:{workout: id})}

  belongs_to :workout
  has_many :workout_per_day_per_exercises, dependent: :destroy
  has_many :exercises, -> {reorder("exercises.name ASC")}, through: :workout_per_day_per_exercises

  validates :name, presence: true
  validates :name, length: {minimum: 3}
  validates :series,:repetition,numericality: { greater_than_or_equal: 1 }
  validates :time, :rest, numericality: { greater_than_or_equal: 0 }

  def self.load_workout_per_days(page = 1, per_page = 10)
    includes(workout: [:user,:trainer], exercises: [:images])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.workout_per_day_by_id(id)
    includes(workout: [:user,:trainer], exercises: [:images])
      .find_by_id(id)
  end

  def self.workout_per_days_by_ids(ids,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where(workout_per_days:{id: ids})
  end

  def self.workout_per_days_by_not_ids(ids, page = 1 ,per_page = 10)
    load_workout_per_days(page,per_page)
      .where.not(workout_per_days:{id: ids})
  end

  def self.workout_per_days_by_name(name,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where("workout_per_days.name LIKE ?", "#{name.downcase}%")
  end

  def self.workout_per_days_by_series(series,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where(workout_per_days:{series: series})
  end

  def self.workout_per_days_by_repetition(repetition,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where(workout_per_days:{repetition: repetition})
  end

  def self.workout_per_days_by_time(time,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where(workout_per_days:{time: time})
  end

  def self.workout_per_days_by_rest(rest, page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where(workout_per_days:{rest: rest})
  end

  def self.workout_per_days_by_workout_id(workout,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .where(workout_per_days:{workout_id: workout})
  end

  def self.workout_per_days_with_exercises(page = 1, per_page = 10)
    joins(:workout_per_day_per_exercises)
      .group("workout_per_days.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(workout_per_day_per_exercises.id)")
  end

end
