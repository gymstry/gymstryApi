class RenameTypeToTrainer < ActiveRecord::Migration[5.0]
  def change
    rename_column :trainers, :type, :type_trainer

  end
end
