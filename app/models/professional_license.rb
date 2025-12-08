class ProfessionalLicense < ApplicationRecord
  belongs_to :user
  belongs_to :issuing_authority

  validates :license_number, presence: true
  validates :expiration_date, presence: true

  validate :validate_license_format

  def status_label
    return "Expired" if expiration_date < Date.today
    return "Expiring Soon" if expiration_date < 3.months.from_now
    "Active"
  end


  private

  def validate_license_format
    # If the Authority has a specific Regex rule, check the number against it
    return unless issuing_authority&.license_format_regex.present?

    # Convert string to Regex object
    regex_rule = Regexp.new(issuing_authority.license_format_regex)
      unless license_number.match?(regex_rule)
        errors.add(:license_number, "does not match the required format for #{issuing_authority.name}")
      end
  end
end
