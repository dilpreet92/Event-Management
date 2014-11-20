require 'spec_helper'

describe Api::V1::EventsController do

  before do
    @current_user = double(:user)
    User.stub(:where).with(:access_token => 'edeed').and_return(@current_user)
    @current_user.stub(:first).and_return(@current_user)
  end

  def set_event
    @event = double(:event)
    Event.stub(:where).with(:id => '146').and_return(@event)
    @event.stub(:first).and_return(@event)
  end

  describe '#callbacks' do
    describe '#set_event' do
      context 'when found' do
        before do
          set_event
          controller.params = ActionController::Parameters.new(id: '146')
        end
        it 'should assign @event' do
          controller.send(:set_event)
          expect(assigns[:event]).to eql @event
        end
      end

      context 'when not found' do
        before do
          controller.params = ActionController::Parameters.new(id: '14600')
        end
        it 'should render json with a message and status 404' do
          controller.should_receive(:render).with(json: {message: 'Event not found'}, status: 404)
          controller.send(:set_event)
        end
      end
    end
  end

  context '#index' do

    def get_index
      get :index, :format => 'json', :token => 'edeed'
    end

    before do
      @events = double(:events)
      Event.stub_chain(:enabled, :live_or_upcoming).and_return(@events)
    end

    it 'should expect a json response' do
      get_index
      expect(response.content_type).to eql 'application/json'
    end

    it 'should render the index template' do
      get_index
      expect(response).to render_template :index
    end
    it 'should assign events' do
      get_index
      expect(assigns[:events]).to eql @events
    end
  end

  context '#attendees' do

    def get_attendees
      get :attendees, :id => 146, :format => 'json', :token => 'edeed'
    end

    before do
      @users = double(:mock)
      set_event
      @event.stub_chain(:attendes).and_return(@users)
    end

    it 'should expect a json response' do
      get_attendees
      expect(response.content_type).to eql 'application/json'
    end

    it 'should render the attendees template' do
      get_attendees
      expect(response).to render_template :attendees
    end
    it 'should assign users' do
      get_attendees
      expect(assigns[:users]).to eql @users
    end
  end

  context '#mine_events' do

    def get_mine_events
      get :mine_events, :format => 'json', :token => 'edeed'
    end

    before do
      @events = double(:events)
      @current_user.stub_chain(:events, :enabled).and_return(@events)
    end

    it 'should expect a json response' do
      get_mine_events
      expect(response.content_type).to eql 'application/json'
    end

    it 'should render mine_events template' do
      get_mine_events
      expect(response).to render_template :mine_events
    end

    it 'should assign events' do
      get_mine_events
      expect(assigns[:events]).to eql @events
    end
  end

  context '#rsvps' do

    def get_rsvps
      get :rsvps, :format => 'json', :token => 'edeed'
    end

    before do
      @events = double(:events)
      @current_user.stub_chain(:attending_events, :enabled).and_return(@events)
    end

    it 'should expect a json response' do
      get_rsvps
      expect(response.content_type).to eql 'application/json'
    end

    it 'should render rsvps' do
      get_rsvps
      expect(response).to render_template :rsvps
    end

    it 'should assign events' do
      get_rsvps
      expect(assigns[:events]).to eql @events
    end
  end
end