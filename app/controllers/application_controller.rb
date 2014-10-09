class ApplicationController < ActionController::Base

  #FIXME_AB: I guess you won't need authenticate in views, so can ignore it as a helper
  helper_method :current_user, :logged_in?, :authenticate
  protect_from_forgery with: :exception

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
      #FIXME_AB: use !!current_user
      current_user
    end

end


#FIXME_AB: remove unused js and css files