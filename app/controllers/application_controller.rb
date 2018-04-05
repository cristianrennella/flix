class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
  	!!current_user
  end

  def require_user
  	access_denied unless logged_in?
  end

  def access_denied
  	flash[:danger] = "You must be logged in."
  	redirect_to login_path
  end

  def wrong_path
    flash[:danger] = "There was an error."
    redirect_to login_path
  end
end
