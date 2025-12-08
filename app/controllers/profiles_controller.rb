class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [ :edit, :update, :show ]

  def edit
  end

  def show
  end


  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = current_user.user_profile || current_user.build_user_profile
  end

  def profile_params
    params.require(:user_profile).permit(
      :full_name,
      :middle_initial,
      :last_name,
      :birthdate,
      :phone_number,
      :address_line_1,
      :address_line_2,
      :city,
      :state,
      :zip_code,
      :bio)
  end
end
