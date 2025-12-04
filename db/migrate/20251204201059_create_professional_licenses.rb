class CreateProfessionalLicenses < ActiveRecord::Migration[8.1]
  def change
    create_table :professional_licenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :issuing_authority, null: false, foreign_key: true
      t.string :license_number
      t.date :expiration_date
      t.string :status

      t.timestamps
    end
  end
end
