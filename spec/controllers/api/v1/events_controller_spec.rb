require 'spec_helper'

describe Api::V1::EventsController do

  before do
    @current_user = double(:user)
    User.stub(:where).with(:access_token => 'edeed').and_return(@current_user)
    @current_user.stub(:first).and_return(@current_user)
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
      @event = double(:event)
      Event.stub(:where).with(:id => '146').and_return(@event)
      @event.stub(:first).and_return(@event)
      @event.stub_chain(:attendes, :uniq).and_return(@users)
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
      @current_user.stub_chain(:attending_events, :enabled, :uniq).and_return(@events)
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