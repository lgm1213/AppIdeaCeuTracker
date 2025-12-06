class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @profile = current_user.user_profile || current_user.build_user_profile
  end


  def update
    @profile = current_user.user_profile || current_user.build_user_profile

    if @profile.update(profile_params)
      redirect_to dashboard_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(
      :full_name, 
      :middle_initial, 
      :last_name, 
      :phone_number, 
      :address, 
      :city, 
      :state, 
      :zip_code, 
      :bio)
  end
end
