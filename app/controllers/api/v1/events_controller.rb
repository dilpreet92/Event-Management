class Api::V1::EventsController < ApplicationController
  
  before_action :restrict_access
  respond_to :json

  def index
    @events = Event.live_and_upcoming
  end

  def attendees
    respond_with Event.where(id: params[:id]).first.attendes.uniq
  end

  def mine_events
    #FIXME_AB: current_user.events.enabled
    respond_with @consumer_user.events.enabled
  end

  def rsvps
    respond_with @consumer_user.attending_events.enabled
  end

end