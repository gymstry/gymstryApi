class CreateWorkoutPerDays < ActiveRecord::Migration[5.0]
  def change
    create_table :workout_per_days do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :benefits, :default => ""
      t.integer :level
      
      t.references :workout, foreign_key: true

      t.timestamps
    end
    add_index :workout_per_days, :name

  end
end
