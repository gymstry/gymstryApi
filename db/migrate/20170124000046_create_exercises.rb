class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :problems, :default => ""
      t.string :benefits, :default => ""
      t.integer :muscle_group, :null => false
      t.text :elements, array: true, default: []
      t.string :owner, :null => false, :default => "admin"
      t.references :trainer, foreign_key: true
      t.integer :level, :default => 0
      t.timestamps
    end
    add_index :exercises, :name
    add_index :exercises, :owner

  end
end
