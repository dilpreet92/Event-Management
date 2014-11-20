require 'spec_helper'

describe Admin::EventsController do

  before do
    controller.stub(:authenticate_admin!).and_return(true)
  end

  def set_event
    @event = double(:event)
    Event.stub(:where).with(id: '106').and_return(@event)
    @event.stub(:first).and_return(@event)
  end

  describe 'callbacks' do
    describe '#past?' do
      context 'when event is past' do
        before do
          @events = double(:events)
          Event.stub_chain(:past, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
          xhr :get, :index, :event => { :filter => 'past' }, :format => 'js'
        end
        it 'should return true' do
          expect(controller.send(:past?)).to be_true
        end
      end

      context 'when event is upcoming?' do
        before do
          @events = double(:events)
          Event.stub_chain(:live_or_upcoming, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
          xhr :get, :index, :event => { :filter => 'upcoming'}, :format => 'js'
        end
        it 'should return false' do
          expect(controller.send(:past?)).to be_false
        end
      end
    end

    describe '#set_event' do
      context 'when event found' do
        before do
          set_event
          controller.params = ActionController::Parameters.new(id: '106')
        end
        it 'should assign @event' do
          controller.send(:set_event)
          expect(assigns[:event]).to eql @event
        end
      end

      context 'when event not found' do
        before do
          controller.params = ActionController::Parameters.new(id: '2000')
        end
        it 'should redirect_to to events_url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, {:alert=>"Event not found or disabled"} )
          controller.send(:set_event)
        end
      
      end
    end
  end

  describe '#index as html request' do
    before do
      @events = double(:events)
      Event.stub_chain(:live_or_upcoming, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
      get :index
    end
    it 'should assign @events' do
      expect(assigns[:events]).to eql @events
    end

    it 'should render index template' do
      expect(response).to render_template :index
    end
  end

  describe '#index as js request' do
    context 'when event is past' do
      before do
        controller.stub(:past?).and_return(true)
        @events = double(:events)
        Event.stub_chain(:past, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
        xhr :get, :index, :event => { :filter => 'past' }, :format => 'js'
      end
      it 'should assign @events' do
        expect(assigns[:events]).to eql @events
      end
      it 'should render index template' do
        expect(response).to render_template :index
      end
    end

    context 'when event is upcoming' do
      before do
        controller.stub(:past?).and_return(false)
        @events = double(:events)
        Event.stub_chain(:live_or_upcoming, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
        xhr :get, :index, :event => { :filter => 'upcoming' }, :format => 'js'
      end
      it 'should assign @events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render index template' do
        expect(response).to render_template :index
      end
    end
  end

  describe '#show' do
    before do
      set_event
      get :show, :id => 106
    end
    it 'should render show template' do
      expect(response).to render_template :show
    end
  end

  describe '#disable' do
    context 'when successfully disabled' do
      before do
        set_event
        @event.stub(:update_attribute).with('enable', false).and_return(true)
        @event.stub(:name).and_return('dp')
        get :disable, :id => 106
      end
      it 'should redirect to admin events url' do
        expect(response).to redirect_to admin_events_url
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql "#{@event.name} successfully disabled"
      end
    end

    context 'when not disabled' do
      before do
        set_event
        @event.stub(:update_attribute).with('enable', false).and_return(false)
        @event.stub(:name).and_return('dp')
        get :disable, :id => 106
      end
      it 'should redirect to admin events url' do
        expect(response).to redirect_to admin_events_url
      end

      it 'should flash a alert' do
        expect(flash[:alert]).to eql "#{@event.name} cannot be disabled"
      end
    end
  end

  describe '#enable' do
    context 'when successfully enabled' do
      before do
        set_event
        @event.stub(:update_attribute).with('enable', true).and_return(true)
        @event.stub(:name).and_return('dp')
        get :enable, :id => 106
      end
      it 'should redirect to admin events url' do
        expect(response).to redirect_to admin_events_url
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql "#{@event.name} successfully enabled"
      end
    end

    context 'when not enabled' do
      before do
        set_event
        @event.stub(:update_attribute).with('enable', true).and_return(false)
        @event.stub(:name).and_return('dp')
        get :enable, :id => 106
      end
      it 'should redirect to admin events url' do
        expect(response).to redirect_to admin_events_url
      end

      it 'should flash an alert' do
        expect(flash[:alert]).to eql "#{@event.name} cannot be enabled"
      end
    end


  end
  
end