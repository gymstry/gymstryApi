class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name, :null => false, :unique => true
      t.text :description, :default => ""
      t.decimal :proteins
      t.decimal :carbohydrates
      t.decimal :fats
      t.text :image
      t.references :food_day, foreign_key: true

      t.timestamps
    end
    add_index :foods, :name
  end
end
