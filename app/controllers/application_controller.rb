class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password) }
    end

  private

    def authenticate
      unless current_user
        redirect_to root_url, notice: "Please log in to create or attend a event"
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end

end
