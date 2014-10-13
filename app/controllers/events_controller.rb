class EventsController < ApplicationController

  before_action :authenticate, except: [:index, :filter, :show, :search]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user?, only: [:edit, :update, :destroy]

  def index
  end

  def filter
    if params[:events][:filter] == 'past'
      @events = get_past_events
    else
      @events = get_live_and_upcoming_events
    end
    respond_to do |format|
      format.js
    end
  end

  def mine
    #FIXED: Better to use it like: current_user.events.enabled.paginate(:page => params[:page], :per_page => 5). Discuss this with me, there is a huge difference between both syntax. Hint: foreign key
    @events = current_user.events.enabled.paginate(:page => params[:page], :per_page => 5)
  end

  def search
    if params[:search].blank?
      @events = get_live_and_upcoming_events.order_by_start_date(:asc)
    else
      @events = get_live_and_upcoming_events.search(params[:search])
    end
  end
  
  def rsvps
    @events = current_user.attending_events.enabled.paginate(:page => params[:page], :per_page => 5).uniq
  end

  def show
  end

  def new
    @event = current_user.events.build
  end

  def edit   
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      redirect_to events_url, notice: 'Event was successfully destroyed.'
    else
      redirect_to events_url, notice: "#{ @event.name } cannot be destroyed "
    end    
  end

  private

    def get_live_and_upcoming_events
      get_enabled_events.live_and_upcoming.order_by_start_date(:asc)
    end

    def get_past_events
      get_enabled_events.past.order_by_start_date(:desc)
    end

    def authorize_user?
      if !@event.owner?(current_user) || @event.past?
        redirect_to events_url, notice: 'Current Activity cannot be performed'
      end  
    end

    def get_enabled_events
      Event.enabled.paginate(:page => params[:page], :per_page => 5)
    end

    def set_event
      @event = Event.where(id: params[:id]).first
      if !@event
        redirect_to events_url, notice: 'Event not found or disabled'
      end    
    end

    def event_params
      params.require(:event).permit(permitted_params)
    end

    def permitted_params
      [ :name, :start_date, :end_date, :address, :city, :country, :contact_number, :description, :enable, :logo ]
    end
end
