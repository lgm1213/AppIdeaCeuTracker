class Ceu < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :date, presence: true
  validates :duration, numericality: { greater_than: 0 }

  
end
