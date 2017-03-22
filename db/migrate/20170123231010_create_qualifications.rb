class CreateQualifications < ActiveRecord::Migration[5.0]
  def change
    create_table :qualifications do |t|
      t.text :description, :null => false, :default => ""
      t.string :name, :null => false
      t.text :qualification
      t.references :trainer, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
    add_index :qualifications, :name
  end
end
