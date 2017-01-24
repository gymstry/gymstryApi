class CreateChallanges < ActiveRecord::Migration[5.0]
  def change
    create_table :challanges do |t|
      t.string :name, :null => false
      t.text :description, :default => ""
      t.integer :type_challange
      t.date :start_date
      t.date :end_date
      t.integer :state
      t.decimal :objective
      t.references :trainer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :challanges, :name
  end
end
