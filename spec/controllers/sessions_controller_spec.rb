require 'spec_helper'

describe SessionsController do
  
  before do
    controller.stub(:admin_signed_in?).and_return(false)
  end

  def set_user
    @user = double(:user)
    User.stub(:find).with(1).and_return(@user)
  end


  def set_event
    @event = double(:event)
    Event.stub(:where).with(:id => "129").and_return(@event)
    @event.stub(:first).and_return(@event)
  end

  def set_session
    @session = double(:session)
    Session.stub(:where).with(:id => "10").and_return(@session)
    @session.stub(:first).and_return(@session)
  end

  def set_rsvp
    set_session
    set_user
    @rsvp = double(:rsvp)
    Rsvp.stub(:find_by).with(session_id: '10', user: @user)
  end

  describe '#callbacks' do
    describe '#set_session' do
      context 'when session found' do
        before do
          set_session
          controller.params = ActionController::Parameters.new(id: '10')
          @session.stub(:enable).and_return(true)
        end
        it 'should assign @session' do
          controller.send(:set_session)
          expect(assigns[:session]).to eql @session
        end
      end

      context 'when session not found' do
        before do
          controller.params = ActionController::Parameters.new(id: '10000')
        end
        it 'should redirect to events url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, alert: 'Session not found')
          controller.send(:set_session)
        end
      end
    end

    describe '#set_event' do
      context 'when event found' do
        before do
          controller.params = ActionController::Parameters.new(event_id: '1')
        end
        it 'should assign @event' do
          controller.send(:set_event)
          expect(assigns[:event]).to be_instance_of(Event)
        end
      end

      context 'when not found' do
        before do
          controller.params = ActionController::Parameters.new(event_id: '14600')
        end
        it 'should redirect to events_url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, alert: 'Event not found or disabled')
          controller.send(:set_event)
        end
      end
    end

    describe '#set_rsvp' do
      context 'when found' do
        before do
          session[:user_id] = 53
          controller.params = ActionController::Parameters.new(session_id: '9')
        end
        it 'should assign @rsvp' do
          controller.send(:set_rsvp)
          expect(assigns[:rsvp]).to be_instance_of(Rsvp)
        end
      end

      context 'when not found' do
        before do
          controller.params = ActionController::Parameters.new(session_id: '13320')
          controller.stub(:current_user).and_return(false)
        end

        it 'should redirect to events_url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, alert: 'Could not perform this operation')
          controller.send(:set_rsvp)
        end
      end
    end

    describe '#check_if_already_attending' do
      context 'when true' do
        before do
          @session = double(:session)
          session[:user_id] = 1
          controller.params = ActionController::Parameters.new(session_id: '9')
          @session.stub(:topic).and_return('dilpreet')
        end
        it 'should assign @session' do
          controller.send(:check_if_already_attending)
          expect(assigns[:session]).to be_instance_of(Session)
        end
        it 'should redirect to events_url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, alert: "You are already attending #{ @session.topic } or session is expired")
          controller.send(:check_if_already_attending)
        end
      end
      context 'when false' do
        it 'should return nil' do
          expect(controller.send(:check_if_already_attending)).to be_nil
        end
      end
    end

    describe '#authorize_user?' do
      context 'when true' do
        before do
          @event = double(:event)
          session[:user_id] = 1
          controller.params = ActionController::Parameters.new(event_id: '1')
          controller.send(:set_event)
        end
        it 'should return nil' do
          expect(controller.send(:authorize_user?)).to be_nil
        end
      end

      context 'when false' do
        before do
          @event = double(:event)
          session[:user_id] = 2
          controller.params = ActionController::Parameters.new(event_id: '1')
          controller.send(:set_event)
        end
        it 'should redirect_to events_url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, alert: 'Current activity cannot be performed')
          controller.send(:authorize_user?)
        end
      end
    end
  end

  context '#new' do
    
    before do
      set_event
      set_user
      controller.stub(:current_user).and_return(@user)
      controller.stub(:authorize_user?).and_return(true)
      @event.stub_chain(:sessions, :build).and_return(@session)
      xhr :get, :new, :event_id => "129"
    end

    it 'should render new template' do
      expect(response).to render_template :new
    end

    it 'should assign session' do
      expect(assigns[:session]).to eql @session
    end

  end

  context '#show' do
    before do
      set_session
      set_user
      controller.stub(:current_user).and_return(@user)
      xhr :get, :show, :event_id => '129', :id => '10'
    end
    it 'should render show template' do
      expect(response).to render_template :show
    end
    it 'should respond to a js request'do
      expect(response.content_type).to eql 'text/javascript'
    end
  end

  context '#edit' do
    
    before do
      set_user
      set_event
      @session = double(:session)
      @event.stub_chain(:sessions, :where).with(:id => "10").and_return(@session)
      @session.stub(:first).and_return(@session)
      controller.stub(:current_user).and_return(@user)
      controller.stub(:authorize_user?).and_return(true)
      xhr :get, :edit, :event_id => 129, :id => 10
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
      @event = mock_model('Event')
      @rsvp = double(:rsvp)
      set_session
      set_user
      controller.stub(:current_user).and_return(@user)
      @user.stub(:attending?).with(@session).and_return(false)
      @session.stub(:enable).and_return(true)
      @session.stub_chain(:rsvps, :build).with(:user => @user).and_return(@rsvp)
      @session.stub(:topic).and_return('dilpreet')
      @session.stub(:event).and_return(@event)
      @session.stub(:upcoming?).and_return(true)
      @session.stub_chain(:event, :name).and_return('dilpreet')
    end

    context 'when saved sucessfully' do

      before do
        @rsvp.stub(:save).and_return(true)
        get :create_rsvp, :event_id => 129, :session_id => 10
      end

      it 'should assign rsvp' do
        expect(assigns[:rsvp]).to eql @rsvp
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash notice' do
        expect(flash[:notice]).to eql "You are now attending #{ @session.topic } of  #{ @session.event.name } "
      end

    end

    context 'when not saved' do

     before do
      @rsvp.stub(:save).and_return(false)
      get :create_rsvp, :event_id => 106, :session_id => 10
     end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash notice' do
        expect(flash[:alert]).to eql 'You cannot attend dilpreet event'
      end

    end

  end

  context '#destroy_rsvp' do
    before do
      @rsvp = double(:rsvp)
      @event = mock_model('Event')
      Event.stub(:where).with(:id => "129").and_return(@event)
      @event.stub(:first).and_return(@event)
      set_user
      controller.stub(:current_user).and_return(@user)
      Rsvp.stub(:find_by).with(:session_id => '10', user: @user).and_return(@rsvp)
      @rsvp.stub_chain(:session, :topic).and_return('dilpreet')
      @rsvp.stub_chain(:session, :event).and_return(@event)
      @rsvp.stub_chain(:session, :event, :name).and_return('dp')
      @rsvp.stub(:destroy).and_return(true)
    end

    it 'should assign rsvp' do
      get :destroy_rsvp, :event_id => 106, :session_id => 10
      expect(assigns[:rsvp]).to eql @rsvp
    end

    context 'when sucessfully destroyed' do

      before do
        get :destroy_rsvp, :event_id => 106, :session_id => 10
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @rsvp.session.event
      end

      it 'should flash notice' do
        expect(flash[:notice]).to eql "You have unattended #{ @rsvp.session.topic } session of #{ @rsvp.session.event.name }"
      end
    end

    context 'when not destroyed' do

      before do
        @rsvp.stub(:destroy).and_return(false)
        get :destroy_rsvp, :event_id => 106, :session_id => 10
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @rsvp.session.event
      end

      it 'should flash notice' do
        expect(flash[:alert]).to eql 'Current operation cannot be performed'
      end
    end
  end

  context '#create' do
    before do
      @event = mock_model("Event")
      @session = double(:session)
      Event.stub(:where).with(:id => '106').and_return(@event)
      @event.stub(:first).and_return(@event)
      set_user
      controller.stub(:current_user).and_return(@user)
      @session_params = { "topic" => "wefwfwwf", 'start_date' =>  "2014-10-22 06:38:00", "end_date" => "2014-10-22 19:38:00", 
        "location" => "fewfwe", "enable" => true, "description" => "fwefwef" }
      @event.stub_chain(:sessions, :build).with(@session_params).and_return(@session)
      @session.stub(:save).and_return(true)
      @session.stub(:topic).and_return('dilpreet')
    end

    def do_post
      post :create, :event_id => 106, :session => @session_params
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
        expect(flash[:notice]).to eql 'Session dilpreet was successfully created.'
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
      @event = mock_model("Event")
      Event.stub(:where).with(:id => '106').and_return(@event)
      @event.stub(:first).and_return(@event)
      set_session
      set_user
      controller.stub(:current_user).and_return(@user)
      @session.stub(:enable).and_return(true)
      @session_params = { "topic" => "wefwfwwf", 'start_date' =>  "2014-10-22 06:38:00", "end_date" => "2014-10-22 19:38:00", 
        "location" => "fewfwe", "enable" => true, "description" => "fwefwef" }
      @session.stub(:update).with(@session_params).and_return(true)
      @session.stub(:event).and_return(@event)
      @session.stub(:topic).and_return('dilpreet')
    end

    def do_put
      put :update, :event_id => 106, :id => 10, :session => @session_params
    end

    context 'when update successfully' do
      it 'should redirect to event' do
        do_put
        expect(response).to redirect_to @session.event
      end
      it 'should flash notice' do
        do_put
        expect(flash[:notice]).to eql 'Session dilpreet was successfully updated.'
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
      @event = mock_model('Event')
      set_session
      Event.stub(:where).with(:id => "129").and_return(@event)
      @event.stub(:first).and_return(@event)
      set_user
      controller.stub(:current_user).and_return(@user)
      @session.stub(:enable).and_return(@event)
      @session.stub_chain(:event).and_return(@event)
      allow(@event).to receive(:owner?).and_return(true)
      allow(@event).to receive(:past?).and_return(false)
      @session.stub(:update_attribute).with("enable", false).and_return(true)
      @session.stub(:topic).and_return('dilpreet')
    end

    it 'should receive update attribute' do
      expect(@session).to receive(:update_attribute).with("enable", false)
      get :disable, :id => 10, :event_id => 129
    end

    context 'when saved sucessfully' do

      before do
        get :disable, :id => 10, :event_id => 129
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql "Session #{ @session.topic } successfully disabled"
      end
    end

    context 'when not saved' do
      before do
        @session.stub(:update_attribute).with('enable', false).and_return(false)
        get :disable, :id => 10, :event_id => 129
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:alert]).to eql "Session #{ @session.topic } cannot be disabled"
      end
      
    end
  end

  context '#enable' do
    before do
      @event = mock_model('Event')
      set_session
      Event.stub(:where).with(:id => "129").and_return(@event)
      @event.stub(:first).and_return(@event)
      set_user
      controller.stub(:current_user).and_return(@user)
      @session.stub(:enable).and_return(@event)
      @session.stub_chain(:event).and_return(@event)
      allow(@event).to receive(:owner?).and_return(true)
      allow(@event).to receive(:past?).and_return(false)
      @session.stub(:update_attribute).with("enable", true).and_return(true)
      @session.stub(:topic).and_return('dilpreet')
    end

    it 'should receive update attribute' do
      expect(@session).to receive(:update_attribute).with("enable", true)
      get :enable, :id => 10, :event_id => 129
    end

    context 'when saved sucessfully' do

      before do
        get :enable, :id => 10, :event_id => 129
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql "Session #{ @session.topic } successfully enabled"
      end
    end

    context 'when not saved' do
      before do
        @session.stub(:update_attribute).with('enable', true).and_return(false)
        get :enable, :id => 10, :event_id => 129
      end

      it 'should redirect to event' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:alert]).to eql "Session #{ @session.topic } cannot be enabled"
      end
      
    end
  end

end