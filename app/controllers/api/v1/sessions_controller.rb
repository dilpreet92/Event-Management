class Api::V1::SessionsController < ApplicationController
  
  respond_to :json

  def index
    respond_with Session.enabled.where(event_id: params[:event_id])
  end

  def attendees
    respond_with Session.enabled.where(id: params[:id]).first.attendes
  end

end