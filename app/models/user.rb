class User < ApplicationRecord
  # Handles password encryption with bcrypt gem
  has_secure_password

  # A user can save MANY CEU Events
  has_many :saved_events, dependent: :destroy
  has_many :saved_ceu_events, through: :saved_events, source: :ceu_event

  # A user has one bio profile
  has_one :user_profile, dependent: :destroy

  # Allows the User form to accept fields for the UserProfile
  accepts_nested_attributes_for :user_profile

  # A user can have MANY licenses (e.g., FL and NY)
  has_many :professional_licenses, dependent: :destroy
  has_many :ceus, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
end
