require 'spec_helper'

describe UsersController do

  before do
    @user = double(:user)
    @events = double(:event)
    User.stub(:find).with(1).and_return(@user)
    controller.stub(:current_user).and_return(@user)
  end

  describe 'private instance methods' do
    describe '#past?' do
      context 'when event is past' do
        before do
          @user.stub_chain(:created_past_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
          xhr :get, :events, :event => { :filter => 'past'}, :format => 'js'
        end
        it 'should return true' do
          expect(controller.send(:past?)).to be_true
        end
      end

      context 'when event is upcoming?' do
        before do
          @user.stub_chain(:created_upcoming_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
          xhr :get, :events, :event => { :filter => 'upcoming'}, :format => 'js'
        end
        it 'should return false' do
          expect(controller.send(:past?)).to be_false
        end
      end
    end
  end

  context '#events when html request' do
    before do
      @user.stub_chain(:created_upcoming_events, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
      get :events
    end

    it 'should assign @events' do
      expect(assigns[:events]).to eql @events
    end

    it 'should render the mine events view' do
      expect(response).to render_template(:events)
    end
  end

  context '#mine_events when js request' do

    context 'when event is past' do

      before do
        @user.stub_chain(:created_past_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        controller.stub(:past?).and_return(true)
        xhr :get, :events, :event => { :filter => 'past'}, :format => 'js'
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
        @user.stub_chain(:created_upcoming_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        controller.stub(:past?).and_return(false)
        xhr :get, :events, :events => { :filter => 'upcoming' }, :format => 'js'
      end

      it 'should assign events to my upcoming events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context '#rsvps when html request' do
    before do
      @user.stub_chain(:upcoming_attending_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
      @events.stub(:uniq).and_return(@events)
      get :rsvps
    end
    it 'should assign @events' do
      expect(assigns[:events]).to eql @events
    end
    it 'should render rsvps template' do
      expect(response).to render_template :rsvps
    end
  end

  context '#rsvps when js request' do

    context 'when event is past' do

      before do
        @user.stub_chain(:past_attended_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        @events.stub(:uniq).and_return(@events)
        controller.stub(:past?).and_return(true)
        xhr :get, :rsvps, :event => { :filter => 'past'}, :format => 'js'
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
        @user.stub_chain(:upcoming_attending_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        @events.stub(:uniq).and_return(@events)
        controller.stub(:past?).and_return(false)
        xhr :get, :rsvps, :events => { :filter => 'upcoming'}, :format => 'js'
      end

      it 'should assign events to my attending events' do
        expect(assigns[:events]).to eql @events
      end

      it 'should render the :filter js' do
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end


end