module ApplicationHelper
  #FIXME_AB: we may need this method in controllers too so add this to application controller and make it helper.
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end  
  end
  
  #FIXME_AB:  no need to have this method. it should go in event model itself. event.upcoming?
  def upcoming_event?(event)
    #FIXME_AB: no need to fire a query.
    Event.upcoming.include?(event)
  end  
end
