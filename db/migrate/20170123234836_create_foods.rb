class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name, :null => false, :unique => true
      t.text :description, :default => ""
      t.decimal :proteins, :null => false, :default => 0
      t.decimal :carbohydrates, :null => false, :default => 0
      t.decimal :fats, :null => false, :default => 0
      t.text :image

      t.timestamps
    end
    add_index :foods, :name
  end
end
