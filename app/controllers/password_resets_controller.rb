class PasswordResetsController < ApplicationController
  # Skip auth check so logged-out users can reset passwords
  skip_before_action :authenticate_user!, raise: false

  def new
    # Renders the "Forgot Password" form
  end

  def create
    @user = User.find_by(email_address: params[:email_address])

    if @user
      @user.generate_password_reset_token!
      UserMailer.with(user: @user).password_reset.deliver_now
    end

    # Always redirect to root with success message to prevent email enumeration
    redirect_to root_path, notice: "If an account with that email exists, we have sent a password reset link."
  end

  def edit
    @user = User.find_by(reset_token: params[:token])
    
    if @user
      puts "🔍 DEBUG: Token Found for user #{@user.email_address}"
      puts "   - Sent At: #{@user.reset_sent_at}"
      puts "   - Time Now: #{Time.current}"
      puts "   - Expired?: #{@user.password_reset_expired?}"
    else
      puts "🔍 DEBUG: No user found with token: #{params[:token]}"
    end

    if @user.nil? || @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password reset link is invalid or has expired."
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])

    if @user.nil? || @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password reset link is invalid or has expired."
      return
    end

    if @user.update(password_params)
      @user.clear_password_reset_token!
      redirect_to login_path, notice: "Password has been reset! Please log in."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end