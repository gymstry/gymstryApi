class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :problems, :default => ""
      t.string :benefits, :default => ""
      t.integer :muscle_group
      t.text :elements, array: true, default: []
      t.integer :level
      t.timestamps
    end
    add_index :exercises, :name

  end
end
