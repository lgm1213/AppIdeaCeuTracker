# Preview all emails at http://localhost:3000/rails/mailers/license_mailer
class LicenseMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/license_mailer/expiring_soon
  def expiring_soon
    LicenseMailer.expiring_soon
  end
end
