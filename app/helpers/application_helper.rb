module ApplicationHelper
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end  
  end
  
  def upcoming_event?(event)
    Event.upcoming.include?(event)
  end  
end
