class CreateWorkoutPerDayPerExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :workout_per_day_per_exercises do |t|
      t.references :workout_per_day, foreign_key: true
      t.references :exercise, foreign_key: true

      t.timestamps
    end
  end
end
