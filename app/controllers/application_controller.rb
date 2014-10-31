class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception

  private

    def authenticate
      unless current_user
        redirect_to root_url, notice: "Please log in to perform the current operation"
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end

    def restrict_access
      if valid_by_params? || valid_by_header?
        @consumer_user
      else
        render json: {message: 'Invalid API Token'}, status: 401
      end
    end

    def valid_by_header?
      authenticate_with_http_token do |token|
        #FIXME_AB: This is actually currentuser. instead of finding him by id we are finding him by access token. 
        @consumer_user = User.where(access_token: token).first
      end
    end

    def valid_by_params?
      @consumer_user = User.where(access_token: params[:token]).first
    end


end
