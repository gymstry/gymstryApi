class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :name, :null => false
      t.date :start_day, :null => false, :default => Date.today
      t.date :end_day, :null => false
      t.text :description, :null => false, :defaut => ""
      t.references :branch, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
