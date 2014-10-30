require 'spec_helper'

describe SessionsController do
  
  before do
    @user = double(:user)
    User.stub(:find).with(1).and_return(@user)
    @user.stub(:id).and_return(1)
    controller.stub(:admin_signed_in?).and_return(false)
    controller.stub(:current_user).and_return(@user)
  end

  context '#new' do
    
    before do
      @event = double(:event)
      @session = double(:session)
      Event.stub(:where).with(:id => "142").and_return(@event)
      @event.stub(:first).and_return(@event)
      @event.stub_chain(:sessions, :build).and_return(@session)
      get :new, :event_id => "142"
    end
    
    it 'should render new template' do
      expect(response).to render_template :new
    end

    it 'should assign session' do
      expect(assigns[:session]).to eql @session
    end

  end

  context '#edit' do
    
    before do
      @event = double(:event)
      @session = double(:session)
      Event.stub(:where).with(:id => "146").and_return(@event)
      @event.stub(:first).and_return(@event)
      @event.stub_chain(:sessions, :where).with(:id => "300").and_return(@session)
      @session.stub_chain(:first).and_return(@session)
      get :edit, :event_id => 146, :id => 300
    end

    it 'should render edit template' do
      expect(response).to render_template :edit
    end

    it 'should assign session' do
      expect(assigns[:session]).to eql @session
    end

  end

  context '#create_rsvp' do
    before do
      @session = double(:session)
      @rsvp = double(:rsvp)
      Session.stub(:where).with(:id => "300").and_return(@session)
      @session.stub(:first).and_return(@session)
      @session.stub_chain(:rsvps, :build).with(:user => @user).and_return(@rsvp)
      @session.stub(:enable).and_return(true)
      @session.stub(:topic).and_return('dilpreet')
      @session.stub_chain(:event, :name).and_return('dilpreet')
      @user.stub(:attending?).with(@session).and_return(false)
    end

    context 'when saved sucessfully' do

      before do
        @rsvp.stub(:save).and_return(true)
        get :create_rsvp, :event_id => 146, :session_id => 300
      end

      it 'should assign rsvp' do
        expect(assigns[:rsvp]).to eql @rsvp
      end

      it 'should redirect to events url' do
        expect(response).to redirect_to events_url
      end

      it 'should flash notice' do
        expect(flash[:notice]).to eql "You are now attending #{ @session.topic } of  #{ @session.event.name } "
      end

    end

    context 'when not saved' do

     before do
      @rsvp.stub(:save).and_return(false)
      get :create_rsvp, :event_id => 146, :session_id => 300
     end

      it 'should redirect to events url' do
        expect(response).to redirect_to events_url
      end

      it 'should flash notice' do
        expect(flash[:notice]).to eql 'You cannot attend this event'
      end

    end

  end

  context '#destroy_rsvp' do
    before do
      @rsvp = double(:rsvp)
      Rsvp.stub(:find_by).with(:session_id => '300', user: @user).and_return(@rsvp)
      @rsvp.stub_chain(:session, :topic).and_return('dilpreet')
      @rsvp.stub(:destroy).and_return(true)
    end

    it 'should assign rsvp' do
      get :destroy_rsvp, :event_id => 146, :session_id => 300
      expect(assigns[:rsvp]).to eql @rsvp
    end

    context 'when sucessfully destroyed' do

      before do
        get :destroy_rsvp, :event_id => 146, :session_id => 300
      end

      it 'should redirect to events url' do
        expect(response).to redirect_to events_url
      end

      it 'should flash notice' do
        expect(flash[:notice]).to eql "You are now not attending #{ @rsvp.session.topic }"
      end
    end

    context 'when not destroyed' do

      before do
        @rsvp.stub(:destroy).and_return(false)
        get :destroy_rsvp, :event_id => 146, :session_id => 300
      end

      it 'should redirect to events url' do
        expect(response).to redirect_to events_url
      end

      it 'should flash notice' do
        expect(flash[:notice]).to eql 'Current operation cannot be performed'
      end
    end
  end

  context '#create' do
    before do
      @event = mock_model("Event")
      @session = double(:session)
      Event.stub(:where).with(:id => '146').and_return(@event)
      @event.stub(:first).and_return(@event)
      @session_params = { "topic" => "wefwfwwf", 'start_date' =>  "2014-10-22 06:38:00", "end_date" => "2014-10-22 19:38:00", 
        "location" => "fewfwe", "speaker" => "wefwef", "enable" => true, "description" => "fwefwef" }
      @event.stub_chain(:sessions, :build).with(@session_params).and_return(@session)
      @session.stub(:save).and_return(true)
    end

    def do_post
      post :create, :event_id => 146, :session => @session_params
    end

    it 'should assign session' do
      do_post
      expect(assigns[:session]).to eql @session
    end

    context 'when successfully saved' do
     
      it 'should redirect to event' do
        do_post
        expect(response).to redirect_to @event
      end
      it 'should flash a notice' do
        do_post
        expect(flash[:notice]).to eql 'Session was successfully created.'
      end
    end

    context 'when not saved' do
      before do
        @session.stub(:save).and_return(false)
      end
      it 'should render new template' do
        do_post
        expect(response).to render_template :new
      end
    end
  end

  context '#update' do
    before do
      @session = double(:session)
      @event = mock_model("Event")
      Event.stub(:where).with(:id => '146').and_return(@event)
      @event.stub(:first).and_return(@event)
      Session.stub(:where).with(:id => '300').and_return(@session)
      @session.stub(:first).and_return(@session)
      @session_params = { "topic" => "wefwfwwf", 'start_date' =>  "2014-10-22 06:38:00", "end_date" => "2014-10-22 19:38:00", 
        "location" => "fewfwe", "speaker" => "wefwef", "enable" => true, "description" => "fwefwef" }
      @session.stub(:update).with(@session_params).and_return(true)
      @session.stub(:event).and_return(@event)
    end

    def do_put
      put :update, :event_id => 146, :id => 300, :session => @session_params
    end

    context 'when update successfully' do
      it 'should redirect to event' do
        do_put
        expect(response).to redirect_to @session.event
      end
      it 'should flash notice' do
        do_put
        expect(flash[:notice]).to eql 'Session was successfully updated.'
      end
    end

    context 'when not updated' do
      before do
        @session.stub(:update).with(@session_params).and_return(false)
      end
      it 'should render :edit template' do
        do_put
        expect(response).to render_template :edit
      end
    end
  end

  context '#disable' do
    before do
      @session = double(:session)
      @event = mock_model("Event")
      Event.stub(:where).with(:id => '146').and_return(@event)
      @event.stub(:first).and_return(@event)
      Session.stub(:where).with(:id => '300').and_return(@session)
      @session.stub(:first).and_return(@session)
      @session.stub(:enable=).with(false).and_return(false)
      @session.stub(:save).with(:validate => false).and_return(true)
      @session.stub(:event).and_return(@event)
    end

    it 'should receive enable = false' do
      expect(@session).to receive(:enable=).with(false)
      get :disable, :id => 300, :event_id => 146
    end

    context 'when saved sucessfully' do

      before do
        get :disable, :id => 300, :event_id => 146
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql 'Session Disabled'
      end
    end

    context 'when not saved' do
      before do
        @session.stub(:save).with(:validate => false).and_return(false)
        get :disable, :id => 300, :event_id => 146
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql 'Session Cannot be disabled'
      end
      
    end
  end

end