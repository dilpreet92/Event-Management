class EventsController < ApplicationController
  skip_before_action :authorize, only: [:index, :show, :upcoming_events, :past_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = enabled_and_apply_pagination
  end

  def my_events
    @events = enabled_and_apply_pagination.where(user_id: session[:user_id])
  end

  def search_events
    if params[:search].blank?
      @events = enabled_and_apply_pagination.upcoming
    else
      @events = enabled_and_apply_pagination.search(params[:search])
    end
  end

  def my_attending_events
    user = User.find(session[:user_id])
    @events = user.attending_events.enabled.paginate(:page => params[:page], :per_page => 5).uniq
  end
  
  def add_to_attendes_list
    event = Event.find(params[:event_id])
    add_to_attendes_list = event.user_session_associations.build(user_id: session[:user_id], session_id: params[:session_id])
    if add_to_attendes_list.save
      redirect_to events_url, notice: "You are now attending #{ event.name }"
    end
  end

  def upcoming_events
    @events = enabled_and_apply_pagination.upcoming
  end

  def past_events
    @events = enabled_and_apply_pagination.past
  end
  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @users = @event.attending_users.uniq
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @user = User.find(session[:user_id])
    @event = @user.events.build(event_params)

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

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
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

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def enabled_and_apply_pagination
      Event.enabled.paginate(:page => params[:page], :per_page => 5)
    end

    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :start_date, :end_date, :start_time, :end_time, :address, :city, :country, :contact_number, :description, :status, :image_url)
    end
end
