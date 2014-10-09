class EventsController < ApplicationController

  before_action :authenticate, except: [:index, :filter, :show, :upcoming_events, :past_events, :search_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_if_user_can_edit_or_delete?, only: [:edit, :update, :destroy]

  def index
  end

  def filter
    if params[:events][:filter] == 'past'
      @events = get_past_events
    else
      @events = get_upcoming_events
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def user_events
    @events = get_enabled_events.where(user_id: current_user.id)
  end

  def search_events
    if params[:search].blank?
      @events = get_enabled_events.upcoming.order_by(:asc)
    else
      @events = get_enabled_events.search(params[:search])
    end
  end
  

  def user_attending_events
    @events = get_enabled_events.where(id: current_user.get_attending_events)
  end

  def show
    @users = @event.get_attendes
  end

  def new
    @event = current_user.events.build
  end

  def edit   
  end

  def create
    @event = current_user.events.build(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_url, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @event.destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to events_url, notice: "#{ @event.name } cannot be destroyed "
    end    
  end

  private

    def get_upcoming_events
      get_enabled_events.upcoming.order_by(:asc)
    end

    def get_past_events
      get_enabled_events.past.order_by(:desc)
    end

    def check_if_user_can_edit_or_delete?
      unless @event.user_id == current_user.id && @event.upcoming?
        redirect_to events_url, notice: 'Current Activity cannot be performed'
      end  
    end

    def get_enabled_events
      Event.enabled.paginate(:page => params[:page], :per_page => 5)
    end

    def set_event
      @event = Event.where(id: params[:id]).first
    end

    def event_params
      params.require(:event).permit(permitted_params)
    end

    def permitted_params
      [ :name, :start_date, :end_date, :address, :city, :country, :contact_number, :description, :enable, :logo ]
    end
end
