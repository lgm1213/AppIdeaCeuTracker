class LicenseMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.license_mailer.expiring_soon.subject
  #
  def expiring_soon
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
