class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @profile = @user.user_profile

    #@licenses = @user.professional_licenses
    #@ceus = @user.ceus
  end


end
