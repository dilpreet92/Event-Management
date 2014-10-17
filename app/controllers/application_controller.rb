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
      unless restrict_access_by_params || restrict_access_by_header
        render json: {message: 'Invalid API Token'}, status: 401
        return
      end

      @current_user = @api_key.user if @api_key
    end

    def restrict_access_by_header
      return true if @api_key

      authenticate_with_http_token do |token|
        @api_key = ApiKey.find_by_token(token)
      end
    end

    def restrict_access_by_params
      return true if @api_key

      @api_key = ApiKey.find_by_token(params[:token])
    end


end
