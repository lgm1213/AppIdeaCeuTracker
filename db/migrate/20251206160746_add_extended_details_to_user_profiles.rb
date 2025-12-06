class AddExtendedDetailsToUserProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :user_profiles, :phone_number, :string
    add_column :user_profiles, :birthdate, :date
    add_column :user_profiles, :address_line_1, :string
    add_column :user_profiles, :address_line_2, :string
    add_column :user_profiles, :zip_code, :string
    add_column :user_profiles, :bio, :text
  end
end
