class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :name, :null => false
      t.date :start_day, :null => false
      t.date :end_day, :null => false
      t.text :description, :defaut => false
      t.references :gym, foreign_key: true

      t.timestamps
    end
  end
end
