class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to edit_account_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    # Separate logic: Password change vs General update (email)
    if account_params[:password].present?
      update_password
    else
      update_details
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted. We are sorry to see you go."
  end

  private

  def account_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :current_password)
  end

  def update_details
    if @user.update_with_password(account_params.except(:password, :password_confirmation))
      redirect_to edit_account_path, notice: "Account details updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_password
    if @user.update_with_password(account_params)
      # Re-login user to prevent logout after password change
      login @user
      redirect_to edit_account_path, notice: "Password updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end
end