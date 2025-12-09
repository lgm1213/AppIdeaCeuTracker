class SavedEvent < ApplicationRecord
  belongs_to :user
  belongs_to :ceu_event
end