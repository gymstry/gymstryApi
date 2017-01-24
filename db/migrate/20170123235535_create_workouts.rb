class CreateWorkouts < ActiveRecord::Migration[5.0]
  def change
    create_table :workouts do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :objective, :default => ""
      t.date :start_date
      t.integer :days
      t.date :end_date
      t.integer :day
      t.integer :level
      t.references :trainer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :workouts, :name

  end
end
