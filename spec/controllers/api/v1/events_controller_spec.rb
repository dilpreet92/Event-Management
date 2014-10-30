require 'spec_helper'

describe Api::V1::EventsController do

  before do
    @user = double(:user)
    User.stub(:where).with(:id => 1).and_return(@user)
    @user.stub(:first).and_return(@user)
    controller.stub(:restrict_access).and_return(@user)
  end

  context '#index' do
    it 'should render the index '
  end

  context '#attendees' do
  end

  context '#mine_events' do
  end

  context '#rsvps' do
  end
end