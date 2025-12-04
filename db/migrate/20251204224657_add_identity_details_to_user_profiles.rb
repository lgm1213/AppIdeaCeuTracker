class AddIdentityDetailsToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :middle_initial, :string
  end
end
