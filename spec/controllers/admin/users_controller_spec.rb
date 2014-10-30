require 'spec_helper'

describe Admin::UsersController do
  before do
    controller.stub(:authenticate_admin!).and_return(true)
  end
  context '#index' do
    before do
      @users =  double(:users)
      User.stub_chain(:all, :paginate).with(:page => '1', :per_page => 5).and_return(@users)
      get :index, :page => '1'
    end

    it 'should render index template' do
      expect(response).to render_template :index
    end

    it 'should assign users' do
      expect(assigns[:users]).to eql @users
    end
  end

  context '#enable' do

    def do_enable
      get :enable, :id => 1
    end

    before do
      @user = double(:user)
      User.stub(:where).with(:id => '1').and_return(@user)
      @user.stub(:first).and_return(@user)
      @user.stub(:enable=).with(true).and_return(true)
      @user.stub(:save).and_return(true)
    end

    context 'when saved successfully' do
      it 'should redirect to admin users url' do
        do_enable
        expect(response).to redirect_to admin_users_url
      end

      it 'should flash notice' do
        do_enable
        expect(flash[:notice]).to eql 'User enabled'
      end
    end

    context 'when not saved' do
      before do
        @user.stub(:save).and_return(false)
      end

      it 'should redirect to admin users url' do
        do_enable
        expect(response).to redirect_to admin_users_url
      end

      it 'should flash notice' do
        do_enable
        expect(flash[:notice]).to eql 'Failed to enable'
      end
    end
  end

  context '#disable' do
    def do_disable
      get :disable, :id => 1
    end
    before do
      @user = double(:user)
      User.stub(:where).with(:id => '1').and_return(@user)
      @user.stub(:first).and_return(@user)
      @user.stub(:enable=).with(false).and_return(true)
      @user.stub(:save).and_return(true)
    end

    context 'when saved successfully' do
      it 'should redirect to admin users url' do
        do_disable
        expect(response).to redirect_to admin_users_url
      end

      it 'should flash notice' do
        do_disable
        expect(flash[:notice]).to eql 'User disabled'
      end
    end

    context 'when not saved' do
      before do
        @user.stub(:save).and_return(false)
      end

      it 'should redirect to admin users url' do
        do_disable
        expect(response).to redirect_to admin_users_url
      end

      it 'should flash notice' do
        do_disable
        expect(flash[:notice]).to eql 'Failed to disable'
      end
    end
  end
end