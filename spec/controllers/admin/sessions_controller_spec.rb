require 'spec_helper'

describe Admin::SessionsController do

  def set_session
    @session = double(:session)
    Session.stub(:where).with(:id => '10').and_return(@session)
    @session.stub(:first).and_return(@session)
  end

  before do
    controller.stub(:authenticate_admin!).and_return(true)
    @event = mock_model('Event')
    Event.stub(:find).with(106).and_return(@event)
  end

  describe '#callbacks' do

    describe '#set_session' do
      context 'when session found' do
        before do
          set_session
          controller.params = ActionController::Parameters.new(id: '10')
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
        it 'should redirect_to events url with a alert message' do
          controller.should_receive(:redirect_to).with(events_url, {:alert=>"Session not found"} )
          controller.send(:set_session)
        end
      end
    end
  end

  describe '#disable' do
    before do
      set_session
      @session.stub(:topic).and_return('dp')
      @session.stub(:event).and_return(@event)
    end
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