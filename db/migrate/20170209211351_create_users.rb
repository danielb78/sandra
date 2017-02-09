class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, index: true, unique: true, null: false
      t.string :password_digest, null: false
      t.string :given_name
      t.string :family_name
      t.timestamp :last_logged_in_at

      # confirmation fields
      t.string :confirmation_token, index: true, unique: true
      t.text :confirmation_redirect_url
      t.timestamp :confirmed_at
      t.timestamp :confirmation_sent_at

      # reset password fields
      t.string :reset_password_token, index: true, unique: true
      t.text :reset_password_redirect_url
      t.timestamp :reset_password_sent_at
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
