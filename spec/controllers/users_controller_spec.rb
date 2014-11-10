require 'spec_helper'

describe UsersController do

  before do
    @user = double(:user)
    @events = double(:event)
    User.stub(:find).with(1).and_return(@user)
    controller.stub(:current_user).and_return(@user)
  end

  context '#mine_events when html request' do
    before do
      @user.stub_chain(:created_upcoming_events, :paginate).with(:page => nil, :per_page => 5).and_return(@events)
      get :mine_events
    end

    it 'should assign @events' do
      expect(assigns[:events]).to eql @events
    end

    it 'should render the mine events view' do
      expect(response).to render_template(:mine_events)
    end
  end

  context '#mine_events when js request' do

    context 'when event is past' do

      before do
        @user.stub_chain(:created_past_events, :paginate).with({:page=>nil, :per_page=>5}).and_return(@events)
        controller.stub(:past?).and_return(true)
        xhr :get, :mine_events, :event => { :filter => 'past'}, :format => 'js'
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
        xhr :get, :mine_events, :events => { :filter => 'upcoming' }, :format => 'js'
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