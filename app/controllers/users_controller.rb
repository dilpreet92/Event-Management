class UsersController < ApplicationController

  layout 'index'

  before_action :authenticate

  def mine_events
    respond_to do |format|
      format.html { @events = current_user.created_upcoming_events.paginate(:page => params[:page], :per_page => 5) }
      format.js do
        if past?
          @events = current_user.created_past_events.paginate(:page => params[:page], :per_page => 5)
        else
          @events = current_user.created_upcoming_events.paginate(:page => params[:page], :per_page => 5)
        end
      end
    end
  end

  def rsvps
    respond_to do |format|
      format.html { @events = current_user.upcoming_attending_events.
                      paginate(:page => params[:page], :per_page => 5).uniq }
      format.js do
        if past?
          @events = current_user.past_attended_events.paginate(:page => params[:page], :per_page => 5).uniq
        else
          @events = current_user.upcoming_attending_events.paginate(:page => params[:page], :per_page => 5).uniq
        end
      end
    end
  end

  private

    def past?
      params[:event][:filter] == 'past'
    end

end
