class DeviseTokenAuthCreateGyms < ActiveRecord::Migration[5.0]
  def change
    create_table(:gyms) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Gym Info
      t.string :name
      t.string :description
      t.string :address
      t.string :telephone
      t.string :email
      t.string :speciality, array: true, default: []
      t.date :birthday

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :gyms, :email,                unique: true
    add_index :gyms, [:uid, :provider],     unique: true
    add_index :gyms, :reset_password_token, unique: true
    add_index :gyms, :confirmation_token,   unique: true
    add_index :gyms, :unlock_token,       unique: true
  end
end
