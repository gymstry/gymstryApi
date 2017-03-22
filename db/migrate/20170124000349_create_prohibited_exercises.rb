class CreateProhibitedExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :prohibited_exercises do |t|
      t.references :exercise, foreign_key: true, on_delete: :cascade
      t.references :medical_record, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
