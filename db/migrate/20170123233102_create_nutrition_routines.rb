class CreateNutritionRoutines < ActiveRecord::Migration[5.0]
  def change
    create_table :nutrition_routines do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :objective,  :default => ""
      t.date :start_date
      t.date :end_date
      t.references :user, foreign_key: true
      t.references :trainer, foreign_key: true

      t.timestamps
    end
    add_index :nutrition_routines, :name
  end
end
