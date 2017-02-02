class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.text :description, :null => false, :default => ""
      t.text :image
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end

end
