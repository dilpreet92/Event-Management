class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception

  private

    def set_session_nil
      if current_user
        session[:user_id], @current_user = nil, nil
      end
    end

    def authenticate
      unless current_user
        redirect_to root_url, alert: "Please log in to perform the current operation"
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
        @current_user
      else
        render json: { message: 'Invalid API Token' }, status: 401
      end
    end

    def valid_by_header?
      authenticate_with_http_token do |token|
        @current_user = User.where(access_token: token).first
      end
    end

    def valid_by_params?
      @current_user = User.where(access_token: params[:token]).first
    end


end
