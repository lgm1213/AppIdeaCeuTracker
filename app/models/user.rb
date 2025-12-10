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

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Password Reset Logic

  def generate_password_reset_token!
    # Uses update_columns instead of update.
    # This skips validations (like password requirements) so the token
    # ALWAYS saves, even if the user record has other issues.
    update_columns(
      reset_token: SecureRandom.urlsafe_base64,
      reset_sent_at: Time.current
    )
  end

  def password_reset_expired?
    # Token expires after 2 hours
    reset_sent_at.nil? || reset_sent_at < 2.hours.ago
  end

  def clear_password_reset_token!
    update(reset_token: nil, reset_sent_at: nil)
  end

  def update_with_password(params)
    current_password = params.delete(:current_password)

    if current_password.blank?
      errors.add(:current_password, "must be provided to make changes")
      return false
    end

    if authenticate(current_password)
      update(params)
    else
      errors.add(:current_password, "is incorrect")
      false
    end
  end
  
end
