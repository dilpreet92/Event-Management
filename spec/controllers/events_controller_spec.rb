require 'spec_helper'

describe EventsController do
  
  context 'Get #index' do

    it 'should render the :index view' do
      get :index
      expect(response).to render_template(:index)
    end

  end

  context 'get #filter' do

    context 'when event is past' do
      
      it 'should render the :filter js' do
        get :filter, :events => { :filter => 'past'}, :format => 'js'
        expect(response.content_type).to eq 'text/javascript'
      end

    end

    context 'when event is upcoming' do
      it 'should render the :filter js' do
        get :filter, :events => { :filter => 'upcoming'}, :format => 'js'
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context 'get #mine_events' do

    context 'when event is past' do
      
      it 'should render the :filter js' do
        get :filter, :events => { :filter => 'past'}, :format => 'js'
        expect(response.content_type).to eq 'text/javascript'
      end

    end

    context 'when event is upcoming' do
      it 'should render the :filter js' do
        get :filter, :events => { :filter => 'upcoming'}, :format => 'js'
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context 'get #attending_filter' do

    context 'when event is past' do
      
      it 'should render the :filter js' do
        get :filter, :events => { :filter => 'past'}, :format => 'js'
        expect(response.content_type).to eq 'text/javascript'
      end

    end

    context 'when event is upcoming' do
      it 'should render the :filter js' do
        get :filter, :events => { :filter => 'upcoming'}, :format => 'js'
        expect(response.content_type).to eq 'text/javascript'
      end
    end

  end

  context 'get #mine' do
    
    context 'when user is logged in' do
   
      it 'should render the :mine events view' do
        session[:user_id] = 1
        get :mine
        expect(response).to render_template(:index)
      end

    end

    context 'when user is not logged in' do
      
      it 'should flash notice Please log in' do
      end

      it 'should redirect to home page' do
      end

    end
  end

end