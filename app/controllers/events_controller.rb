class EventsController < ApplicationController

  layout 'index', except: [:show, :edit, :new, :create, :update]

  #if admin is logged in there is no need to check authentication
  before_action :set_session_nil, if: :admin_signed_in?
  before_action :authenticate, except: [:index, :show, :search]
  before_action :empty_search?, only: [:search]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :disable, :enable]
  before_action :authorize_user?, unless: :admin_signed_in?, only: [:edit, :update, :disable, :enable]
  before_action :hide_event_if_user_disabled, unless: :admin_signed_in?, only: [:show]

  def index
    respond_to do |format|
      format.html { @events = Event.enabled.live_or_upcoming.paginate(:page => params[:page], :per_page => 5) }
      format.js do
        if past?
          @events = Event.enabled.past.paginate(:page => params[:page] ,:per_page => 5)
        else
          @events = Event.enabled.live_or_upcoming.paginate(:page => params[:page], :per_page => 5)
        end
      end
    end
  end

  def search
    @events = Event.enabled.live_or_upcoming.eager_load(:sessions)
              .search(params[:search].strip.downcase).paginate(:page => params[:page] ,:per_page => 5)
    respond_to do |format|
      format.js
    end
  end

  def show
  end

  def new
    @event = current_user.events.build
  end

  def edit
  end

  def create
    @event = current_user.events.build(permitted_params)
    if @event.save
      redirect_to @event, notice: " Event #{ @event.name } successfully created."
    else
      render :new
    end
  end

  def update
    if @event.update(permitted_params)
      redirect_to @event, notice: "Event #{ @event.name } was successfully updated."
    else
      render :edit
    end
  end

  def disable
    if @event.update_attribute('enable', false)
      redirect_to events_url, notice: "Event #{ @event.name } successfully disabled"
    else
      redirect_to events_url, alert: "Event #{ @event.name } cannot be disabled"
    end
  end

  def enable
    if @event.update_attribute('enable', true)
      redirect_to events_url, notice: "Event #{ @event.name } successfully enabled"
    else
      redirect_to events_url, alert: "Event #{ @event.name } cannot be enabled"
    end
  end

  private

    def hide_event_if_user_disabled
      redirect_to events_url, alert: "Creator of the user is currently disabled" unless @event.user.enabled?
    end

    def past?
      params[:event][:filter] == 'past'
    end

    def authorize_user?
      if !@event.owner?(current_user) || @event.past?
        redirect_to events_url, alert: 'Current activity cannot be performed'
      end
    end

    def set_event
      @event = Event.where(id: params[:id]).first
      if @event.nil?
        redirect_to events_url, alert: 'Event not found or disabled'
      end
    end

    def empty_search?
      if params[:search].blank?
        render :js => "window.location = '/events'"
      end
    end

    def permitted_params
      params.require(:event).permit(event_params)
    end

    def event_params
      [ :name, :start_date, :end_date, 
        :address, :city, :country,
        :contact_number, :description, :enable, :logo ]
    end
end
