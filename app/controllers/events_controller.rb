class EventsController < ApplicationController

  skip_before_action :authenticate, only: [:index, :show, :upcoming_events, :past_events, :search_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = get_enabled_events
  end

  def my_events
    @events = get_enabled_events.where(user_id: current_user.id)
  end

  def search_events
    if params[:search].blank?
      @events = get_enabled_events.upcoming
    else
      @events = get_enabled_events.search(params[:search])
    end
  end


  def my_attending_events
    @events = get_enabled_events.find(current_user.get_attending_events)
  end
  

  def upcoming_events
    @events = get_enabled_events.upcoming
  end

  def past_events
    @events = get_enabled_events.past
  end

  def show
    @users = @event.get_attendes
  end

  def new
    @event = current_user.events.build
  end

  def edit
    if @event.user_id == current_user.id && @event.upcoming?
      render :edit
    else
      redirect_to events_url, notice: "Cannot edit #{ @event.name }"
    end    
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
    if @event.user_id == current_user.id && @event.upcoming?
      respond_to do |format|
        if @event.update(event_params)
          format.html { redirect_to @event, notice: 'Event was successfully updated.' }
          format.json { render :show, status: :ok, location: @event }
        else
          format.html { render :edit }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to events_url, notice: 'Cannot update the current event'
    end   
  end

  def destroy
    if @event.user_id == current_user.id && @event.destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to 'events_url', notice: "#{ event.name } cannot be destroyed "
    end    
  end

  private

    def get_enabled_events
      Event.enabled.paginate(:page => params[:page], :per_page => 5)
    end

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :start_date, :end_date, :address, :city, :country, :contact_number, :description, :enable, :image_url)
    end
end
