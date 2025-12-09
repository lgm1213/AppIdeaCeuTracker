class LicenseMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.license_mailer.expiring_soon.subject
  #
  default from: "notifications@appidea-ceutracker.com"

  def expiring_soon
    # We use params to pass data into the mailer (set in the call: LicenseMailer.with(...))
    @user = params[:user]
    @license = params[:license]
    
    # Calculate days remaining for the email body
    @days_left = (@license.expiration_date - Date.today).to_i

    # Trigger the email
    mail(
      to: @user.email_address, 
      subject: "Action Required: #{@license.issuing_authority.name} Expiring Soon"
    )
  end
end
