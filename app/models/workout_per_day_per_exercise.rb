class WorkoutPerDayPerExercise < ApplicationRecord
  belongs_to :workout_per_day
  belongs_to :exercise
end
