require 'spec_helper'

describe Api::V1::EventsController do

  before do
    @user = double(:user)
    User.stub(:where).with(:id => 1).and_return(@user)
    @user.stub(:first).and_return(@user)
    controller.stub(:restrict_access).and_return(@user)
  end

  context '#index' do
    before do
      @events = double(:events)
      Event.stub_chain(:enabled, :live_and_upcoming).and_return(@events)
      get :index, :format => 'json'
    end
    it 'should render the index template' do
      expect(response).to render_template :index
    end
    it 'should assign events' do
      expect(assigns[:events]).to eql @events
    end
  end

  context '#attendees' do
    it 'should render the attendees template'
    it 'should assign users'
  end

  context '#mine_events' do
    it 'should render mine_events template'
    it 'should assign events'
  end

  context '#rsvps' do
    it 'should render rsvps'
    it 'should assign events'
  end
end