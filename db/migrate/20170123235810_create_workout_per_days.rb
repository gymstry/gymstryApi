class CreateWorkoutPerDays < ActiveRecord::Migration[5.0]
  def change
    create_table :workout_per_days do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :benefits, :default => ""
      t.integer :level, :null => false, :default => 0
      t.integer :order, :null => false, :default => 0

      t.references :workout, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
    add_index :workout_per_days, :name
    add_index :workout_per_days, [:order,:workout_id], unique: true
  end
end
