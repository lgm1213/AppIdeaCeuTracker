class Ceu < ApplicationRecord
  belongs_to :user

  # Enables Active Storage for CEU certificate uploads
  has_one_attached :certificate

  validates :title, presence: true
  validates :date, presence: true
  validates :duration, numericality: { greater_than: 0 }
end
