class User < ApplicationRecord
  has_secure_password

  # A user has one bio profile
  has_one :user_profile, dependent: :destroy
  
  # A user can have MANY licenses (e.g., FL and NY)
  has_many :professional_licenses, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
end