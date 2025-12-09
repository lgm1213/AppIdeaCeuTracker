class UserMailer < ApplicationMailer
  default from: "notifications@appidea-ceutracker.com"

  def password_reset
    @user = params[:user]
    
    mail(
      to: @user.email_address, 
      subject: "Reset your password"
    )
  end
end