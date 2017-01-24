class WorkoutPerDay < ApplicationRecord
  belongs_to :workout
  has_many :exercises, -> {reorder("exercises.name ASC")}
end
