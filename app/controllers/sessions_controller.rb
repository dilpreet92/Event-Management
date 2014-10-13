class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :edit, :update, :destroy ]
  before_action :authenticate
  before_action :set_event, only: [:new, :edit, :create]
  before_action :set_rsvp, only: [:destroy_rsvp]
  before_action :check_if_already_attending, only: [:create_rsvp]

  def new
    @session = @event.sessions.build
  end

  def edit
    @session = @event.sessions.where(id: params[:id]).first
  end

  def create_rsvp
    #FIXME_AB: use .build(user: current_user), if you don't know why, ask me
    rsvp = @session.rsvps.build(user_id: current_user.id)
    if rsvp.save
      redirect_to events_url, notice: "You are now attending #{ @session.topic } of  #{ @session.event.name } "
    else
      redirect_to events_url, notice: 'You cannot attend this event'
    end
  end

  def destroy_rsvp
    if @rsvp.destroy
      redirect_to events_url, notice: "You are now not attending #{ @rsvp.session.topic }"
    else
      redirect_to events_url, notice: 'Current operation cannot be performed'
    end  
  end

  def create
    @session = @event.sessions.build(session_params)
    if @session.save
      redirect_to @event, notice: 'Session was successfully created.'
    else
      render :new
    end
  end

  def update
    if @session.update(session_params)
      redirect_to @session.event, notice: 'Session was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @session.destroy
      redirect_to @session.event, notice: 'Session was successfully destroyed.'
    else
      redirect_to @session.event, notice: 'Session cannot be destroyed'
    end
  end

  private
    
    def check_if_already_attending
      @session = Session.where(id: params[:session_id]).first
      #FIXME_AB: use exists? 
      if @session.attendes.include?(current_user)
        redirect_to events_url, notice: "You are already attending #{ @session.topic }"
      end  
    end

    def set_rsvp
      @rsvp = Rsvp.find_by(session_id: params[:session_id], user_id: current_user.id)
      if !@rsvp
        redirect_to events_url, notice: 'Could not perform this operation'
      end
    end

    def set_session 
      @session = Session.where(id: params[:id]).first
      if !@session
        redirect_to events_url, notice: 'Session not found or disabled'
      end
    end
    
    def set_event
      @event = Event.where(id: params[:event_id]).first
      if !@event
        redirect_to events_url, notice: 'Event not found or disabled'
      end  
    end

    def session_params
      params.require(:session).permit(get_permitted_params)
    end

    def get_permitted_params
      [:topic, :start_date, :end_date, :location, :speaker, :description, :status, :event_id]
    end
end
