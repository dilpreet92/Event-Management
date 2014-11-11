class Admin::EventsController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_event, only: [:show, :disable, :enable]

  def index
    respond_to do |format|
      format.html do
        @events = Event.live_or_upcoming.paginate(:page => params[:page], :per_page => 5)
       end
      format.js do
        if past?
          @events = Event.past.paginate(:page => params[:page] ,:per_page => 5)
        else
          @events = Event.live_or_upcoming.paginate(:page => params[:page], :per_page => 5)
        end
      end
    end
    render '/events/index'
  end

  def show
    render template: '/events/show', layout: 'application'
  end

  def disable
    if @event.update_attribute('enable', false)
      redirect_to admin_events_url, notice: "#{@event.name} successfully disabled"
    else
      redirect_to admin_events_url, alert: "#{@event.name} cannot be disabled"
    end
  end

  def enable
    if @event.update_attribute('enable', true)
      redirect_to admin_events_url, notice: "#{@event.name} successfully enabled"
    else
      redirect_to admin_events_url, alert: "#{@event.name} cannot be enabled"
    end
  end

  private

    def past?
      params[:event][:filter] == 'past'
    end

    def set_event
      @event = Event.where(id: params[:id]).first
      if @event.nil?
        redirect_to events_url, alert: 'Event not found or disabled'
      end
    end

end