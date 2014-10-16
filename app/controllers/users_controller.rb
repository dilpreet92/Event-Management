class UsersController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_user, only: [:enable, :disable]

  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 5)
  end

  def enable
    @user.enable = true
    if @user.save
      redirect_to users_url, notice: 'User enabled'
    else
      redirect_to users_url, notice: 'Failed to enable'
    end
  end

  def disable
    @user.enable = false
    if @user.save
        redirect_to users_url, notice: 'User disabled'
      else
        redirect_to users_url, notice: 'Failed to disable'
      end
  end

  private

    def set_user
      @user = User.where(id: params[:id]).first
      if !@user
        redirect_to users_url, notice: 'User not found'
      end  
    end

end