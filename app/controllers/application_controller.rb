class ApplicationController < ActionController::Base

  before_action :authenticate
  helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception

  def authenticate
    unless current_user
      redirect_to root_url, notice: "Please log in"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

end
