class CreateRoutines < ActiveRecord::Migration[5.0]
  def change
    create_table :routines do |t|
      t.integer :series, :default => 4
      t.integer :repetition, :default => 12
      t.decimal :time, :default => 0
      t.decimal :rest, :default => 5
      t.integer :level
      t.references :exercise, foreign_key: true

      t.timestamps
    end
  end
end
