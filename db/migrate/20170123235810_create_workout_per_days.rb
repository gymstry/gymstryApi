class CreateWorkoutPerDays < ActiveRecord::Migration[5.0]
  def change
    create_table :workout_per_days do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :benefits, :default => ""
      t.integer :series, :default => 4
      t.integer :repetition, :default => 12
      t.decimal :time, :default => 0
      t.decimal :rest, :default => 5
      t.references :workout, foreign_key: true

      t.timestamps
    end
    add_index :workout_per_days, :name

  end
end
