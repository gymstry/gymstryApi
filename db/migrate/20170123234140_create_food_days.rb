class CreateFoodDays < ActiveRecord::Migration[5.0]
  def change
    create_table :food_days do |t|
      t.integer :type_food, :null => false
      t.text :description,  :default => ""
      t.text :benefits, :default => ""
      t.references :nutrition_routine, foreign_key: true

      t.timestamps
    end
  end
end
