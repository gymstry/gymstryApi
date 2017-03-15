class Routine < ApplicationRecord

  default_scope {order("routines.created_at ASC")}
  scope :order_by_series, -> (ord) {order("routines.series #{ord}")}
  scope :order_by_repetiton, -> (ord) {order("routines.repetition #{ord}")}
  scope :order_by_time, -> (ord) {order("routines.time #{ord}")}
  scope :order_by_rest, -> (ord) {order("routines.rest #{ord}")}
  scope :order_by_create_at, -> (ord) {order("routines.created_at #{ord}")}
  scope :order_by_level, -> (ord) {order("routines.level #{ord}")}
  scope :search_by_exercise_id, -> (id) {where(routines:{exercise_id: id})}

  has_many :workout_per_day_per_exercises, dependent: :destroy
  has_many :workout_per_days, through: :workout_per_day_per_exercises
  belongs_to :exercise

  enum level:{
    :beginner => 0,
    :intermediate => 1,
    :advanced => 2
  }

  validates :level,presence: true
  validates :series,:repetition,numericality: { greater_than_or_equal: 1 }
  validates :time, :rest, numericality: { greater_than_or_equal: 0 }
  validates :level, inclusion: {in: levels.keys}

  def self.load_routines(page = 1,per_page = 10)
    includes(:workout_per_days,exercise:[:pictures])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.routine_by_id(id)
    includes(:workout_per_days,exercise:[:pictures])
      .find_by_id(id)
  end

  def self.routines_by_ids(ids,page = 1, per_page = 10)
    load_routines(page,per_page)
      .where(routines:{id: ids})
  end

  def self.routines_by_not_ids(ids,page = 1, per_page = 10)
    load_routines(page,per_page)
      .where.not(routines:{id: ids})
  end

  def self.routines_by_series(series,page = 1, per_page = 10)
    load_routines(page,per_page)
      .where(workout_per_days:{series: series})
  end

  def self.routines_by_repetition(repetition,page = 1, per_page = 10)
    load_routines(page,per_page)
      .where(workout_per_days:{repetition: repetition})
  end

  def self.routines_by_time(time,page = 1, per_page = 10)
    load_routines(page,per_page)
      .where(workout_per_days:{time: time})
  end

  def self.routines_by_rest(rest, page = 1, per_page = 10)
    load_routines(page,per_page)
      .where(workout_per_days:{rest: rest})
  end

  def self.routines_by_exercise_id(id,page = 1, per_page = 10)
    load_routines(page,per_page)
      .search_by_exercise_id(id)
  end

end
