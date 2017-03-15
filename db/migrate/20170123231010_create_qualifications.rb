class CreateQualifications < ActiveRecord::Migration[5.0]
  def change
    create_table :qualifications do |t|
      t.text :description
      t.string :name, :null => false
      t.text :description, :default => ""
      t.text :qualification
      t.references :trainer, foreign_key: true

      t.timestamps
    end
    add_index :qualifications, :name
  end
end
