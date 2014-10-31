class Admin::UsersController < ApplicationController

  layout 'index'

  before_action :authenticate_admin!
  before_action :set_user, only: [:enable, :disable]

  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 5)
  end

  def enable
    if @user.update(:enabled => true)
      redirect_to admin_users_url, notice: 'User enabled'
    else
      redirect_to admin_users_url, notice: 'Failed to enable'
    end
  end

  def disable
    if @user.update(:enabled => false)
        redirect_to admin_users_url, notice: 'User disabled'
    else
        redirect_to admin_users_url, notice: 'Failed to disable'
    end
  end

  private

    def set_user
      @user = User.where(id: params[:id]).first
      #FIXED: instead of if !@user I would prefer if @user.nil?. This looks more readable to me
      if @user.nil?
        redirect_to users_url, notice: 'User not found'
      end  
    end

end