class CreateDiseases < ActiveRecord::Migration[5.0]
  def change
    create_table :diseases do |t|
      t.string :name, :null => false, :unique => true
      t.text :description

      t.timestamps
    end
    add_index :diseases, :name
  end
end
