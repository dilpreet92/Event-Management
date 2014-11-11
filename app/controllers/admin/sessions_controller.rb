class Admin::SessionsController < ApplicationController
  
  before_action :authenticate_admin!
  before_action :set_session, only: [:enable, :disable]

  def disable
    if @session.update_attribute('enable', false)
      redirect_to @session.event, notice: "#{ @session.topic } disabled"
    else
      redirect_to @session.event, alert: "#{ @session.topic } cannot be disabled"
    end    
  end

  private

    def set_session
      @session = Session.where(id: params[:id]).first
      if @session.nil?
        redirect_to events_url, alert: 'Session not found'
      end
    end

end