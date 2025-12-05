class CreateCeus < ActiveRecord::Migration[8.1]
  def change
    create_table :ceus do |t|
      t.string :title
      t.date :date
      t.decimal :duration
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
