class CreateMedicalRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_records do |t|
      t.text :observation, :default => ""
      t.decimal :weight, :null => false
      t.string :medication, :null => false, :default => ""
      t.decimal :body_fat_percentage, :null => false
      t.decimal :waist, :null => false
      t.decimal :hips, :null => false
      t.decimal :chest, :null => false
      t.references :user, foreign_key: true, index: {unique: true}

      t.timestamps
    end
  end
end
