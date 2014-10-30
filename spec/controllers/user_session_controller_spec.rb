require 'spec_helper'

describe UserSessionController do

  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
  end

  describe '#create' do

    it 'should successfully create a user' do
      expect {
        get :create, provider: :twitter
      }.to change{ User.count }.by(1)
    end
    
    context 'when user is enabled' do
      before do
        get :create, provider: :twitter
      end
  
      it 'should set set session user id' do
        expect(session).not_to be_empty
      end

      it 'should redirect to home page with a flash message Signed in!' do
        expect(response).to redirect_to root_url
        expect(flash[:notice]).to eql 'Signed in!'
      end

    end

  end

  describe '#destroy' do

    before do
      delete :destroy
    end

    it 'should reset session' do
      expect(session[:user_id]).to be_nil
    end

    it 'should redirect to home page' do
      expect(response).to redirect_to root_path
    end

    it 'should flash a notice' do
      expect(flash[:notice]).not_to be_nil
    end

  end

  describe '#failure' do

    before do
      get :failure
    end

    it 'should redirect to page' do
      expect(response).to redirect_to root_path
    end

    it 'should flash a alert' do
      expect(flash[:alert]).to eql 'Authentication error ' 
    end

  end

end