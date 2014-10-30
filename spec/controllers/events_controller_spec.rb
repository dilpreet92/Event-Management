require 'spec_helper'

describe EventsController do

  before do
    @user = double(:user)
    User.stub(:find).with(1).and_return(@user)
    controller.stub(:admin_signed_in?).and_return(false)
    controller.stub(:current_user).and_return(@user)
  end
  
  context '#index' do

    it 'should render the :index view' do
      get :index
      expect(response).to render_template(:index)
    end

  end

  context '#filter' do

    context 'when admin signed in' do

      before do
        controller.stub(:admin_signed_in?).and_return(true)
      end

    end

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

  context '#mine_events' do

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

  context '#attending_filter' do

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

  context '#mine' do

    it 'should render the :mine events view' do
      get :mine
      expect(response).to render_template(:mine)
    end

  end


  context '#search' do

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

  context '#rsvps' do

    it 'should render the :rsvps view' do
      get :rsvps
      expect(response).to render_template(:rsvps)
    end

  end

  context '#show' do

    it 'should render the :show view' do
      get :show, :id => 1
      expect(response).to render_template(:show)
    end

  end

  context '#new' do

    before do
      @event = double(:event)
      @user.stub_chain(:events, :build).and_return(@event)
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

  context '#create' do
    before do
      @event = mock_model("Event")
      @event_params = { "name" => "dilpreet", "start_date" => "2014-10-23 06:13:05", "end_date" => "2014-10-26 06:13:05",
        "address" => "Hno. 1234", "city" => "Delhi", "country" => "India", "contact_number" => "131313", "description" => "ddqqdqdqd",
        "enable" => true }
    end

    def do_post
      post :create, { :event => @event_params }
    end

    context 'when logged in' do

      before do
        @user.stub_chain(:events, :build).with(@event_params).and_return(@event)
        @event.stub(:save).and_return(true)
      end

      it 'should assign event' do
        do_post
        expect(assigns[:event]).to eql @event
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
        do_post
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

  context '#update' do

    before do
      @event = mock_model("Event")
      Event.stub(:where).with(:id => '142').and_return(@event)
      @event.stub(:first).and_return(@event)
      @event.stub(:update).and_return(true)
      controller.stub(:authorize_user?).and_return(true)
    end

    def do_put(params = {})
      put :update, :id => '142', :event => {  "name" => "dsds" }
    end

    it 'should find the event' do
      event_params = { :name => 'dsds' }
      expect(Event).to receive(:where).with(:id => '142')
      do_put(event_params)
    end

    it 'should update the event' do
      event_params = { "name" => 'dsds' }
      expect(@event).to receive(:update).with(event_params).and_return(true)
      do_put(event_params)
    end

    it 'should redirect to event path' do
      event_params = { "name" => 'dsds' }
      do_put(event_params)
      expect(response).to redirect_to @event
    end

    it 'should flash notice' do
      event_params = { "name" => 'dsds' }
      do_put(event_params)
      expect(flash[:notice]).to eql 'Event was successfully updated.'
    end

    it 'should render edit: view' do
      @event.stub(:update).and_return(false)
      do_put
      expect(response).to render_template :edit
    end

  end
  
  context '#disable' do
   
    before do
      @event = double(:event)
      Event.stub(:where).with(:id => '142').and_return(@event)
      @event.stub(:first).and_return(@event)
      @event.stub(:enable=).and_return(false)
      @event.stub(:save).with(validate: false).and_return(true)
      controller.stub(:authorize_user?).and_return(:true)
      get :disable, :id => 142
    end

    it 'should assign event to current event' do
      expect(assigns[:event]).to eql @event
    end

    it 'should redirect to events page' do
      expect(response).to redirect_to events_url
    end

    it 'should flash a notice Event successfully disabled' do
      expect(flash[:notice]).to eq 'Event successfully Disabled'
    end
         
  end 

end