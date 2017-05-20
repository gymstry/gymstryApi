class CreateWorkouts < ActiveRecord::Migration[5.0]
  def change
    create_table :workouts do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :objective, :default => ""
      t.date :start_date, :null => false, :default => Date.today
      t.integer :days, :null => false
      t.date :end_date, :null => false, :default =>  Date.today + 7
      t.integer :day, :default => 0
      t.integer :level, :defuaul => 0
      t.references :trainer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :workouts, :name

  end
end
