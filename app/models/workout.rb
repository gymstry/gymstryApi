class Workout < ApplicationRecord
  belongs_to :user
  belongs_to :trainer
  has_many :workout_per_day, -> {reorder("workout_per_days.name ASC")}, dependent: :destroy
end
