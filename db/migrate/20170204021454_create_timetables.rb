class CreateTimetables < ActiveRecord::Migration[5.0]
  def change
    create_table :timetables do |t|
      t.date :day, :null => false
      t.string :open_hour, :null => false
      t.string :close_hour, :null => false
      t.boolean :repeat, :default => true
      t.boolean :closed, :default => false
      t.references :branch, foreign_key: true

      t.timestamps
    end
  end
end
