class WorkoutPerDay < ApplicationRecord

  default_scope {order("workout_per_days.name ASC")}

  belongs_to :workout
  has_many :workout_per_day_per_exercises, dependent: :destroy
  has_many :exercises, -> {reorder("exercises.name ASC")}, through: :workout_per_day_per_exercises

  validates :name, presence: true
  validates :name, length: {minimum: 3}
  validates :series,:repetition,numericality: { greater_than_or_equal: 1 }
  validates :time, :rest, numericality: { greater_than_or_equal: 0 }

end
