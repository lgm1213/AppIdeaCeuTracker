class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :user_signed_in?

  private

  # finds the user based on the session user_id
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # returns true if a user is logged in
  def user_signed_in?
    current_user.present?
  end

  # Secures pages, redirects if not logged in
  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "You must be logged in to access that page."
    end
  end

  # logs in the user
  def login(user)
    session[:user_id] = user.id
  end

  #logs out the user
  def logout
    reset_session
    @current_user = nil
  end
end
