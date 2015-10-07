class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?
  def current_user
    @current_user ||= User.find_by(auth_token: cookies.signed[:auth_token]) if cookies[:auth_token]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    deny_access unless logged_in?
  end
  
  private
  def deny_access
    redirect_to login_path
  end


end
