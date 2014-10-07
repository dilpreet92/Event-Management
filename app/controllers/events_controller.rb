class EventsController < ApplicationController
  skip_before_action :authorize, only: [:index, :show, :upcoming_events, :past_events, :search_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  #FIXME_AB: need authorization on controller level not in views

  # GET /events
  # GET /events.json
  def index
    @events = enabled_and_apply_pagination
  end

  def my_events
    #FIXME_AB: user current_user.id instaed of session[:user_id]
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
    #FIXME_AB: current_user
    user = User.find(session[:user_id])
    #FIXME_AB: user.attending_events should be returning unique events only
    @events = user.attending_events.enabled.paginate(:page => params[:page], :per_page => 5).uniq
  end
  
  #FIXME_AB: can be named as rsvp
  def add_to_attendes_list
    #FIXME_AB: Since it is a event's session specific action so should be in your event session controller
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
    #FIXME_AB: it shoudl be event.attendees which would return unique users.
    @users = @event.attending_users.uniq
  end

  # GET /events/new
  def new
    #FIXME_AB: current_user.events.build
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    #FIXME_AB: only the creator of event can be able to edit
  end

  # POST /events
  # POST /events.json
  def create
    #FIXME_AB: user current_user here current_user.events.build....
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
    #FIXME_AB: only the creator of event can be able to edit

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
    #FIXME_AB: only owner / super admin can destroy 
    #FIXME_AB: what if there was an excepton in destroy or it was not destroyed
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #FIXME_AB: get_enabled_events
    def enabled_and_apply_pagination
      Event.enabled.paginate(:page => params[:page], :per_page => 5)
    end

    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :start_date, :end_date, :address, :city, :country, :contact_number, :description, :status, :image_url)
    end
end
