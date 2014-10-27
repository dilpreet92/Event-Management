class Api::V1::SessionsController < ApplicationController
  
  before_action :restrict_access
  before_action :set_session, only: [:rsvp, :create_rsvp]
  respond_to :json

  def index
    #FIXME_AB: event.sessions.enabled
    respond_with Session.enabled.where(event_id: params[:event_id])
  end

  def attendees
    respond_with Session.enabled.where(id: params[:id]).first.attendes
  end

  def rsvp
    respond_with @consumer_user.attending?(@session)
  end

  def create_rsvp
    rsvp = @session.rsvps.build(user: @consumer_user)
    respond_with rsvp.save    
  end

  def destroy_rsvp
    #FIXME_AB: session.rsvps.find_by
    rsvp = Rsvp.find_by(session_id: params[:id], user_id: @consumer_user.id)
    respond_with rsvp.destroy
  end

  private

    def set_session
      @session = Session.where(id: params[:id]).first
      if !@session
        render json: {message: 'Resource not found'}, status: 404
      end
    end

end