class CreateMedicalRecordByDiseases < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_record_by_diseases do |t|
      t.references :medical_record, foreign_key: true, on_delete: :cascade
      t.references :disease, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
