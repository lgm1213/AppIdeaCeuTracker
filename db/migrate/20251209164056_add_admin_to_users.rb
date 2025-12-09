class AddAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    # Default is false so new signups are NOT admins automatically
    add_column :users, :admin, :boolean, default: false
  end
end