class ApplicationController < ActionController::Base
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  #FIXME_AB: Learn about it a bit and explain.  
  protect_from_forgery with: :exception
  
  def authorize
    #FIXME_AB: as discussed if we have moved current_user to application controller, we can us that here.
    unless User.find_by(id: session[:user_id])
      redirect_to root_url, notice: "Please log in"
    end
  end

end
