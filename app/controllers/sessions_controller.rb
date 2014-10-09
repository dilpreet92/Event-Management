class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :edit, :update, :destroy ]
  before_action :authenticate
  before_action :set_event, only: [:new, :edit, :create]

  def new
    @session = @event.sessions.build
  end

  def edit
    @session = @event.sessions.where(id: params[:id]).first
  end

  def add_to_attendes_list
    session = Session.where(id: params[:session_id]).first
    rsvp = session.rsvps.build(user_id: current_user.id)
    if rsvp.save
      redirect_to events_url, notice: "You are now attending #{ session.topic } of  #{ session.event.name } "
    else
      redirect_to events_url, notice: 'You cannot attend this event'
    end
  end

  def remove_from_attendes_list
    rsvp = Rsvp.find_by(session_id: params[:session_id], user_id: current_user.id)
    rsvp.destroy
    redirect_to events_url
  end

  def create
    @session = @event.sessions.build(session_params)
    respond_to do |format|
      if @session.save
        format.html { redirect_to @event, notice: 'Session was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @session.event, notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @session.destroy
    respond_to do |format|
      format.html { redirect_to sessions_url, notice: 'Session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.where(id: params[:id]).first
    end
    
    def set_event
      @event = Event.where(id: params[:event_id]).first
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(get_permitted_params)
    end

    def get_permitted_params
      [:topic, :start_date, :end_date, :location, :speaker, :description, :status, :event_id]
    end
end
