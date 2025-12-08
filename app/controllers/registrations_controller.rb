class RegistrationsController < ApplicationController
  def new
    @user = User.new
    # Creates an empty profile object for the nested fields form to work
    @user.build_user_profile
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      # Log the User into app when they register, immediately
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Welcome #{@user.user_profile.full_name}! Your account has been created."
    else
      # if Save fails, reload the form with the errors displayed
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    # Explicitly allows the nested attributes for user_profile
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      user_profile_attributes: [
        :first_name,
        :middle_initial,
        :last_name,
        :job_title,
        :employer,
        :city,
        :state
      ]
    )
  end
end
