require 'spec_helper'

describe EventsController do

  before do
    @user = double(:user)
    User.stub(:find).with(1).and_return(@user)
    controller.stub(:admin_signed_in?).and_return(false)
    controller.stub(:current_user).and_return(@user)
  end
  
  context 'Get #index' do

    it 'should render the :index view' do
      get :index
      expect(response).to render_template(:index)
    end

  end

  context 'get #filter' do

    context 'when event is past' do

      before do
        @events = double(:events)
        Event.stub_chain(:past, :order_by_start_date).with(:desc).and_return(@events)
        get :filter, :events => { :filter => 'past'}, :format => 'js'
      end

      it 'should assign @events to past events' do
        expect(assigns[:events]).to eql @events
      end
      
      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end

    end

    context 'when event is upcoming' do

      before do
        @events = double(:events)
        Event.stub_chain(:live_and_upcoming, :order_by_start_date).with(:asc).and_return(@events)
        get :filter, :events => { :filter => 'upcoming'}, :format => 'js'
      end

      it 'should assign events to upcoming events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context 'get #mine_events' do

    before do
      @events = double(:events)
    end

    context 'when event is past' do

      before do
        @user.stub_chain(:events, :enabled, :past, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        get :mine_filter, :events => { :filter => 'past'}, :format => 'js'
      end

      it 'should assign events to my past events' do
        expect(assigns[:events]).to eql @events
      end
      
      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end

    end

    context 'when event is upcoming' do

      before do
        @user.stub_chain(:events, :enabled, :live_and_upcoming, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        get :mine_filter, :events => { :filter => 'upcoming' }, :format => 'js'
      end

      it 'should assign events to my upcoming events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context 'get #attending_filter' do

    before do
      @events = double(:events)
      @duplicate_events = double(:dup_events)
    end

    context 'when event is past' do

      before do
        @user.stub_chain(:attending_events, :enabled, :past, :paginate).with({:page=>nil, :per_page=>5}).and_return(@duplicate_events)
        @duplicate_events.stub(:uniq).and_return(@events)
        get :attending_filter, :events => { :filter => 'past'}, :format => 'js'
      end

      it 'should assign events to my attending events' do
        expect(assigns[:events]).to eql @events
      end
      
      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end

    end

    context 'when event is upcoming' do

      before do
        @user.stub_chain(:attending_events, :enabled, :live_and_upcoming, :paginate).with({:page=>nil, :per_page=>5}).and_return(@duplicate_events)
        @duplicate_events.stub(:uniq).and_return(@events)
        get :attending_filter, :events => { :filter => 'upcoming'}, :format => 'js'
      end

      it 'should assign events to my attending events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context 'get #mine' do

    it 'should render the :mine events view' do
      get :mine
      expect(response).to render_template(:mine)
    end

  end


  context 'get #search' do

    context 'when no paramaters is assigned' do

      before do
        @events = double(:events)
        Event.stub_chain(:live_and_upcoming, :order_by_start_date).with(:asc).and_return(@events)
        get :search, :search => '', :format => 'js'
      end

      it 'assign events to all upcoming events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :search js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end

    context 'when a query is passed as parameters' do
      
      before do
        @events = double(:events)
        @upcoming_events = double(:upcoming)
        @association = double(:association)
        @duplicate_events = double(:duplicate_events)
        Event.stub_chain(:live_and_upcoming, :order_by_start_date).with(:asc).and_return(@upcoming_events)
        @upcoming_events.stub_chain(:eager_load).with(:sessions).and_return(@association)
        @association.stub(:search).with('dp').and_return(@duplicate_events)
        @duplicate_events.stub(:uniq).and_return(@events)
        get :search, :search => 'dp', :format => 'js'
      end

      it 'should assign events according to events that are searched for' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :search js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end
  end

  context 'get #rsvps' do

    it 'should render the :rsvps view' do
      get :rsvps
      expect(response).to render_template(:rsvps)
    end

  end

  context 'get #show' do

    it 'should render the :show view' do
      get :show, :id => 1
      expect(response).to render_template(:show)
    end

  end

  context 'get #new' do

    before do
      @event = double(:event)
      controller.stub(:authenticate).and_return(@user)
      # @user.stub(:events, :build).and_return(@event)
      get :new
    end

    it 'should assign @event' do
      expect(assigns[:event]).not_to be_nil
    end

    it 'should render the template :new' do
      expect(response).to render_template(:new)
    end

  end

  context 'get #edit' do

    before do
      controller.stub(:authorize_user?).and_return(:true)
      get :edit, :id => 142
    end

    it 'should render the :edit view' do
      expect(response).to render_template(:edit)
    end

  end

  context 'post #create' do
    before do
      @event = double(:event)
      Event.stub(:new).and_return(@event)
      @event.stub(:save).and_return(true)
      @event_params = { name: "dilpreet", start_date: "2014-10-23 06:13:05", end_date: "2014-10-26 06:13:05",
       address: "Hno. 1234", city: "Delhi", country: "India", contact_number: "131313", description: "ddqqdqdqd",
        enable: true, created_at: "2014-10-22 06:13:05", updated_at: "2014-10-22 06:13:05", user_id: 1 }
    end

    def do_post
      post :create, { :event => @event_params }
    end

    context 'when logged in' do

      before do
        @user.stub(:events, :build).with(@event_params).and_return(@event)
      end

      it 'should save the new event' do
        expect(@event).to receive(:save)
        do_post
      end

      it 'should redirect to event page' do
        do_post
        expect(response).to redirect_to(event_path(@event))
      end

      it 'should flash a notice' do
        do_post
        expect(flash[:notice]).to eql 'Event was successfully created.'
      end

      it 'should render :new when not saved' do
        @event.stub(:save).and_return(false)
        expect(response).to render_template :new
      end

    end

    context 'when not logged in' do

      before do
        controller.stub(:admin_signed_in?).and_return(false)
        controller.stub(:current_user).and_return(false)
      end

      it 'should flash notice Please log in' do
        do_post
        expect(flash[:notice]).to eql 'Please log in to perform the current operation'
      end

    end

  end

  context 'post #update' do

    def do_put(params = {})
      put :update, :id => 134, :event => {  name: "ff", start_date: "2014-10-23 06:13:05", end_date: "2014-10-26 06:13:05",
        address: "Hno. 1234", city: "Delhi", country: "India", contact_number: "13341313", description: "ddqqdqdqd",
        enable: true, created_at: "2014-10-22 06:13:05", updated_at: "2014-10-22 06:13:05", user_id: 1 }.merge(params)
    end

    before do
      @event = double(:event)
      Event.stub(:find).and_return(@event)
      @event.stub(:update).and_return(true)
      controller.stub(:authorize_user?).and_return(true)
    end

    it 'should find the event' do
      event_params = { :name => 'ddf' }
      expect(Event).to receive(:find).with(134)
      do_put(event_params)
    end

    it 'should update the event' do
      event_params = { :name => 'dsds' }
      expect(@event).to receive(:update).with(event_params).and_return(true)
      do_put(event_params)
    end

    it 'should redirect to event path' do
      event_params = { :name => 'dsdsff' }
      do_put(event_params)
      expect(response.status).to eql 200
    end

    it 'should flash notice' do
      event_params = { :name => 'ddddddd' }
      do_put(event_params)
      expect(flash[:notice]).to eql 'Event was successfully updated.'
    end

    it 'should render edit: view' do
      @event.stub(:update).and_return(false)
      do_put
      expect(response).to render_template :edit
    end

  end
  
  context 'get #disable' do
   
    before do
      @user = double(:user)
      @event = double(:event)
      @proxy_event = double(:proxy_event)
      Event.stub(:where).with(:id => '1').with().and_return(@proxy_event)
      @proxy_event.stub(:first).and_return(@event)
      User.stub(:find).and_return(@user)
      controller.stub(:admin_signed_in?).and_return(false)
      controller.stub(:current_user).and_return(@user)
      controller.stub(:authorize_user?).and_return(:true)
    end

    it 'should assign event to current event' do
      get :disable, :id => 1
      expect(assigns[:event]).to eql @event
    end

    it 'should redirect to events page' do
      get :disable, :id => 1
      expect(response).to redirect_to events_url
    end

    it 'should flash a notice Event successfully disabled' do
      get :disable, :id => 1
      expect(flash[:notice]).to eq 'Event successfully Disabled'
    end

  end 

end