class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.decimal :weight, :null => false
      t.decimal :hips, :null => false
      t.decimal :chest, :null => false
      t.decimal :body_fat_percentage, :null => false
      t.decimal :waist, :null => false
      t.references :user, foreign_key: true
      t.references :trainer, foreign_key: true

      t.timestamps
    end
  end
end
