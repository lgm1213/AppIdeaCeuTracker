class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @profile = @user.user_profile

    @licenses = @user.professional_licenses
    @ceus = @user.ceus

    #Filters licenses expiring between Today and 90 days from now
    @expiring_licenses = @licenses.where(expiration_date: Date.today..90.days.from_now).count  
  end


end
