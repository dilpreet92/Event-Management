class Api::V1::SessionsController < ApplicationController
  
  before_action :restrict_access
  before_action :set_session, only: [:rsvp, :create_rsvp]
  respond_to :json

  def index
    respond_with Session.enabled.where(event_id: params[:event_id])
  end

  def attendees
    respond_with Session.enabled.where(id: params[:id]).first.attendes
  end

  def rsvp
    respond_with @current_user.attending?(@session)
  end

  def create_rsvp
    rsvp = @session.rsvps.build(user: current_user)
    if rsvp.save
      respond_with true
    else
      respond_with false
    end     
  end

  def destroy_rsvp
    rsvp = Rsvp.find_by(session_id: params[:id], user_id: current_user.id)
    if rsvp.destroy
      respond_with true
    else
      respond_with false
    end  
  end

  private

    def set_session
      @session = Session.where(id: params[:id]).first
      if !@session
        render json: {message: 'Resource not found'}, status: 404
      end
    end

end