require 'spec_helper'

describe ApplicationController do

  def set_user
    @user = double(:user)
    User.stub(:find).with(1).and_return(@user)
  end

  describe '#set_session_nil' do
    context 'when user logged in' do
      before do
        controller.stub(:current_user).and_return(true)
      end
      it 'should set session to nil' do
        controller.send(:set_session_nil)
        expect(session[:user_id]).to be_nil
      end
    end
    context 'when user not logged in' do
      before do
        controller.stub(:current_user).and_return(false)
      end
      it 'should return nil' do
        expect(controller.send(:set_session_nil)).to be_nil
      end
    end
  end

  describe '#current_user' do
    context 'when session is set' do
      before do
        session[:user_id] = 1
        set_user
      end
      it 'should return user' do
        controller.send(:current_user)
        expect(assigns[:current_user]).to eql @user
      end
    end

    context 'when session is not set' do
      before do
        session[:user_id] = nil
      end
      it 'should return nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe '#authenticate' do
    context 'when user logged in' do
      before do
        controller.stub(:current_user).and_return(true)
      end
      it 'should return nil' do
        expect(controller.send(:authenticate)).to be_nil
      end
    end

    context 'when not logged in' do
      before do
        controller.stub(:current_user).and_return(false)
      end
      it 'should redirect to root_url with a alert message' do
        controller.should_receive(:redirect_to).with(root_url, alert: "Please log in to perform the current operation")
        controller.send(:authenticate)
      end
    end
  end

  describe '#logged_in?' do
    
    context 'when logged in' do
      before do
        controller.stub(:current_user).and_return(true)
      end
      it 'should return true' do
        expect(controller.send(:logged_in?)).to be_true
      end
    end

    context 'when not logged in' do
      before do
        controller.stub(:current_user).and_return(false)
      end
      it 'should return false' do
        expect(controller.send(:logged_in?)).to be_false
      end
    end
  end

  describe '#restrict_access' do
    context 'when valid' do
      before do
        set_user
        controller.params = ActionController::Parameters.new(token: 'edeed')
        controller.send(:valid_by_params?)
      end
      it 'should assign user' do
        controller.send(:restrict_access)
        expect(assigns[:current_user]).to be_instance_of(User)
      end
    end
    context 'when not valid' do
      before do
        controller.stub(:valid_by_params?).and_return(false)
        controller.stub(:valid_by_header?).and_return(false)
      end
      it 'should render json with message and status 401' do
        controller.should_receive(:render).with(json: { message: 'Invalid API Token' }, status: 401)
        controller.send(:restrict_access)
      end
    end
  end

  describe '#valid_by_header?' do
    context 'when valid token' do
      before do
        token = ActionController::HttpAuthentication::Token
        @credentials = token.encode_credentials('edeed')
        request.headers['Authorization'] = @credentials
      end
      it 'should assign user' do
        controller.send(:valid_by_header?)
        expect(assigns[:current_user]).to be_instance_of(User) 
      end
    end

    context 'when token invalid' do
      before do
        basic = ActionController::HttpAuthentication::Basic 
        @credentials = basic.encode_credentials('token', 'edeedsdsdsd')
        request.headers['Authorization'] = @credentials
      end
      it 'should return false' do
        expect(controller.send(:valid_by_header?)).to be_false
      end
    end
  end

  describe '#valid by params?' do
    before do
      controller.params = ActionController::Parameters.new(token: 'edeed')
    end
    context 'when valid token' do
      before do
        controller.send(:valid_by_params?)
      end
      it 'should assign user' do
        expect(assigns[:current_user]).to be_instance_of(User)
      end 
    end

    context 'when token invalid' do
      before do
        controller.params = ActionController::Parameters.new(token: 'sdsdsdsdsdsdsdsds')
      end
      it 'should return false' do
        expect(controller.send(:valid_by_params?)).to be_false
      end
    end
  end
   
end