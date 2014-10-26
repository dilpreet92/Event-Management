class UserSessionController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    if user && user.enable
      reset_session
      session[:user_id] = user.id
      redirect_to root_url, :notice => 'Signed in!'
    else
      redirect_to root_url, notice: 'Authentication error'
    end    
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error "
  end
end
