class CreateSavedEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :saved_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ceu_event, null: false, foreign_key: true

      t.timestamps
    end
    # Ensure a user can't save the same event twice
    add_index :saved_events, [ :user_id, :ceu_event_id ], unique: true
  end
end
