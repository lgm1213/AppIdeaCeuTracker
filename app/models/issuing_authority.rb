class IssuingAuthority < ApplicationRecord
  has_many :professional_licenses
  
  validates :name, presence: true
  validates :state, presence: true
end
