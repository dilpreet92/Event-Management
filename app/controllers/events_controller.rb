class EventsController < ApplicationController

  layout 'index', except: [:show, :edit, :new, :create, :update]

  #if admin is logged in there is no need to check authentication
  before_action :set_session_nil, if: :admin_signed_in?
  before_action :authenticate, unless: :admin_signed_in?, except: [:index, :show, :search]
  before_action :empty_search?, only: [:search]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :disable, :enable]
  before_action :authorize_user?, unless: :admin_signed_in?, only: [:edit, :update, :disable, :enable]

  def index
    respond_to do |format|
      format.html { @events = get_live_or_upcoming_events }
      format.js do
        if past?
          @events = get_past_events
        else
          @events = get_live_or_upcoming_events
        end
      end
    end
  end

  def search
    @events = get_live_or_upcoming_events.eager_load(:sessions).search(params[:search].strip.downcase).uniq
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
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(permitted_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def disable
    if @event.update_attribute('enable', false)
      redirect_to events_url, notice: 'Event successfully Disabled'
    else
      redirect_to events_url, alert: 'Event cannot be disabled'
    end
  end

  def enable
    if @event.update_attribute('enable', true)
      redirect_to events_url, notice: 'Event successfully Enabled'
    else
      redirect_to events_url, alert: 'Event cannot be enabled'
    end
  end

  private

    def past?
      params[:event][:filter] == 'past'
    end

    def get_live_or_upcoming_events
      get_enabled_events.live_or_upcoming.order_by_start_date(:asc)
    end

    def get_past_events
      get_enabled_events.past.order_by_start_date(:desc)
    end

    def authorize_user?
      if !@event.owner?(current_user) || @event.past?
        redirect_to events_url, alert: 'Current Activity cannot be performed'
      end
    end

    def get_enabled_events
      Event.enabled.paginate(:page => params[:page], :per_page => 5)
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
