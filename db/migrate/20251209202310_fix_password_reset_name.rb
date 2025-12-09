class FixPasswordResetName < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :password_reset_token, :reset_token
    rename_column :users, :password_reset_sent_at, :reset_sent_at
  end
end