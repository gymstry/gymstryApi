class CreateFoodDayPerFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :food_day_per_foods do |t|
      t.references :food, foreign_key: true, on_delete: :restrict
      t.references :food_day, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
