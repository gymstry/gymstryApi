class WorkoutPerDay < ApplicationRecord

  default_scope {order("workout_per_days.name ASC")}

  belongs_to :workout
  has_many :exercises, -> {reorder("exercises.name ASC")}

  validates :name, presence: true
  validates :name, length: {minimum: 3}
  validates :series,:repetition,numericality: { greater_than_or_equal: 1 }
  validates :time, :rest, numericality: { greater_than_or_equal: 0 }
  
end
