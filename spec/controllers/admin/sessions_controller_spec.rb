require 'spec_helper'

describe Admin::SessionsController do
  before do
    controller.stub(:authenticate_admin!).and_return(true)
    @session = double(:session)
    @event = mock_model('Event')
    Event.stub(:find).with(106).and_return(@event)
    Session.stub(:where).with(:id => '10').and_return(@session)
    @session.stub(:first).and_return(@session)
    @session.stub(:topic).and_return('dp')
    @session.stub(:event).and_return(@event)
  end

  describe '#disable' do
    context 'when disabled successfully' do
      before do
        @session.stub(:update_attribute).with('enable', false).and_return(true)
        get :disable, :id => '10', :event_id => 106
      end
      it 'should redirect to event path' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a notice' do
        expect(flash[:notice]).to eql "#{ @session.topic } disabled"
      end
    end
    context 'when not disabled' do
      before do
        @session.stub(:update_attribute).with('enable', false).and_return(false)
        get :disable, :id => '10', :event_id => '106'
      end
      it 'should redirect to event path' do
        expect(response).to redirect_to @session.event
      end

      it 'should flash a alert' do
        expect(flash[:alert]).to eql "#{ @session.topic } cannot be disabled"
      end
    end
  end
end