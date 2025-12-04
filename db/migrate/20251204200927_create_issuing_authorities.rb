class CreateIssuingAuthorities < ActiveRecord::Migration[8.1]
  def change
    create_table :issuing_authorities do |t|
      t.string :name
      t.string :state
      t.string :license_format_regex

      t.timestamps
    end
  end
end
