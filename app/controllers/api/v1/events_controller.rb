class Api::V1::EventsController < ApplicationController
  
  before_action :restrict_access
  before_action :set_event, only: [:attendees]
  respond_to :json

  def index
    @events = Event.enabled.live_and_upcoming
  end

  def attendees
    @users = @event.attendes.uniq
  end

  def mine_events
    #FIXED: current_user.events.enabled
    @events = @current_user.events.enabled
  end

  def rsvps
    @events = @current_user.attending_events.enabled.uniq
  end

  private 

    def set_event
      @event = Event.where(id: params[:id]).first
      if @event.nil?
        render json: {message: 'Event not found'}, status: 404
      end
    end

end