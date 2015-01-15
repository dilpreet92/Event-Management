class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :update, :destroy, :disable, :enable]
  #skip authentication when admin is signed in
  before_action :authenticate, unless: :admin_signed_in?, except: :show
  before_action :set_event, only: [:new, :edit, :create, :update, :disable, :enable]
  before_action :set_rsvp, only: [:destroy_rsvp]
  before_action :check_if_already_attending, only: [:create_rsvp]
  before_action :authorize_user?, only: [:new, :create, :update]
  before_action :authorize_user?, unless: :admin_signed_in?, only: [:edit, :disable, :enable]

  def new
    @session = @event.sessions.build
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @session = @event.sessions.where(id: params[:id]).first
  end

  def create_rsvp
    @rsvp = @session.rsvps.build(user: current_user)
    if @rsvp.save
      redirect_to @session.event, notice: "You are now attending #{ @session.topic } of  #{ @session.event.name } "
    else
      redirect_to @session.event, alert: "You cannot attend #{ @session.event.name } event"
    end
  end

  def destroy_rsvp
    if @rsvp.destroy
      redirect_to @rsvp.session.event, notice: "You have unattended #{ @rsvp.session.topic } session of #{ @rsvp.session.event.name }"
    else
      redirect_to @rsvp.session.event, alert: 'Current operation cannot be performed'
    end
  end

  def create
    @session = @event.sessions.build(permitted_params)
    if @session.save
      redirect_to @event, notice: "Session #{ @session.topic } was successfully created."
    else
      render :new
    end
  end

  def update
    if @session.update(permitted_params)
      redirect_to @session.event, notice: "Session #{ @session.topic } was successfully updated."
    else
      render :edit
    end
  end

  def disable
    if @session.update_attribute('enable', false)
      redirect_to @session.event, notice: "Session #{ @session.topic } successfully disabled"
    else
      redirect_to @session.event, alert: "Session #{ @session.topic } cannot be disabled"
    end    
  end

  def enable
    if @session.update_attribute('enable', true)
      redirect_to @session.event, notice: "Session #{ @session.topic } successfully enabled"
    else
      redirect_to @session.event, alert: "Session #{ @session.topic } cannot be enabled"
    end
  end


  private

    def authorize_user?
      if !@event.owner?(current_user) || @event.past?
        redirect_to events_url, alert: 'Current activity cannot be performed'
      end
    end

    def check_if_already_attending
      @session = Session.where(id: params[:session_id]).first
      if current_user.attending?(@session) || !@session.upcoming?
        redirect_to events_url, alert: "You are already attending #{ @session.topic } or session is expired"
      end  
    end

    def set_rsvp
      @rsvp = Rsvp.find_by(session_id: params[:session_id], user: current_user)
      if @rsvp.nil?
        redirect_to events_url, alert: 'Could not perform this operation'
      end
    end

    def set_session 
      @session = Session.where(id: params[:id]).first
      if @session.nil?
        redirect_to events_url, alert: 'Session not found'
      end
    end
    
    def set_event
      @event = Event.where(id: params[:event_id]).first
      if @event.nil?
        redirect_to events_url, alert: 'Event not found or disabled'
      end  
    end

    def permitted_params
      params.require(:session).permit(session_params)
    end

    def session_params
      [:topic, :start_date, :end_date, :location, :enable, :description, :event_id, :speakers_attributes => [:id, :name, :twitter_handle, :_destroy] ]
    end
end
