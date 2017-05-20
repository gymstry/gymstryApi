class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.string :otro_name, :null => false, :default => ""
      t.datetime :class_date, :default => DateTime.now
      t.decimal :duration, :default => 1, :null => false
      t.integer :type_event, :default => 0
      t.text :image
      t.references :branch, foreign_key: true
      t.timestamps
    end
    add_index :events, :name
  end
end
