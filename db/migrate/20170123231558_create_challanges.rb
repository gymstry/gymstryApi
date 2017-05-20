class CreateChallanges < ActiveRecord::Migration[5.0]
  def change
    create_table :challanges do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.integer :type_challange
      t.date :start_date, :null => false, :default => Date.today
      t.date :end_date, :null => false, :default =>  Date.today + 7 #Minimum a week
      t.integer :state, :default => 0
      t.decimal :objective
      t.references :trainer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :challanges, :name
  end
end
