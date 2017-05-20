class WorkoutPerDay < ApplicationRecord

  default_scope {order("workout_per_days.id ASC, workout_per_days.order ASC")}
  scope :order_by_name, -> (ord) {order("workout_per_days.name #{ord}")}
  scope :search_by_workout_id, -> (id) {where(workout_per_days:{workout: id})}
  scope :order_by_level, -> (ord) {order("workout_per_days.level #{ord}")}

  belongs_to :workout
  has_many :workout_per_day_per_exercises, dependent: :destroy
  has_many :routines, -> {reorder("exercises.name ASC")}, through: :workout_per_day_per_exercises

  enum level:{
    :beginner => 0,
    :intermediate => 1,
    :advanced => 2
  }

  validates :name,:level, presence: true
  validates :name, length: {minimum: 3}
  validates :level, inclusion: {in: levels.keys}


  def self.load_workout_per_days(page = 1, per_page = 10)
    includes(workout: [:user,:trainer], routines: [:exercise])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.workout_per_day_by_id(id)
    includes(workout: [:user,:trainer], routines: [:exercise])
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

  def self.workout_per_days_by_workout_id(workout,page = 1, per_page = 10)
    load_workout_per_days(page,per_page)
      .search_by_workout_id(workout)
  end

  def self.workout_per_days_with_routines(page = 1, per_page = 10)
    joins(:workout_per_day_per_exercises)
      .group("workout_per_days.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(workout_per_day_per_exercises.id)")
  end

end
