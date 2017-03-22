class CreateNutritionRoutines < ActiveRecord::Migration[5.0]
  def change
    create_table :nutrition_routines do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :objective,  :default => ""
      t.date :start_date, :null => false, :default => Date.today
      t.date :end_date, :null => false, :default => Date.today + 7
      t.references :user, foreign_key: true, on_delete: :destroy
      t.references :trainer, foreign_key: true, on_delete: :nullify

      t.timestamps
    end
    add_index :nutrition_routines, :name
  end
end
