class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.decimal :weight, :null => false, :default => 0
      t.decimal :hips, :null => false, :default => 0
      t.decimal :chest, :null => false, :default => 0
      t.decimal :body_fat_percentage, :null => false, :default => 0
      t.decimal :waist, :null => false, :default => 0
      t.references :user, foreign_key: true
      t.references :trainer, foreign_key: true

      t.timestamps
    end
  end
end
