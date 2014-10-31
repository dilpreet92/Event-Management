class Api::V1::SessionsController < ApplicationController
  
  before_action :restrict_access
  before_action :set_session, only: [:rsvp, :create_rsvp, :destroy_rsvp, :attendees]
  before_action :set_event, only: [:index]
  respond_to :json

  def index
    #FIXED: event.sessions.enabled
     @sessions = @event.sessions.enabled
  end

  def attendees
    @users = @session.attendes
  end

  def rsvp
    if @current_user.attending?(@session)
      render json: { status: 'attending'  }
    else
      render json: { status: 'not attending' }
    end    
  end

  def create_rsvp
    @rsvp = @session.rsvps.build(user: @current_user)
    if @rsvp.save
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'unsuccessfull' }, status: 404
    end
  end

  def destroy_rsvp
    #FIXED: session.rsvps.find_by
    @rsvp = @session.rsvps.find_by(user: @current_user)
    if @rsvp.destroy
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'unsuccessfull' }, status: 404
    end
  end

  private

    def set_session
      @session = Session.where(id: params[:id]).first
      if @session.nil?
        render json: {message: 'Resource not found'}, status: 404
      end
    end

    def set_event
      @event = Event.where(id: params[:event_id]).first
      if @event.nil?
        render json: {message: 'Event not found'}, status: 404
      end
    end

end