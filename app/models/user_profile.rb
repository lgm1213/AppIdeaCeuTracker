class UserProfile < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, presence: true

  def full_name
    [ first_name, last_name ].compact.join(" ")
  end
end
