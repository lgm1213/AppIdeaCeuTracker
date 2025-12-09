class CreateCeuEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :ceu_events do |t|
      t.string :title
      t.string :provider
      t.string :event_type
      t.string :category
      t.decimal :credits, precision: 4, scale: 2
      t.datetime :date
      t.string :location
      t.string :url
      t.text :description
      t.string :timestamps

      t.timestamps
    end
    add_index :ceu_events, :event_type
    add_index :ceu_events, :category
  end
end
