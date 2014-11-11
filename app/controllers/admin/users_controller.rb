class Admin::UsersController < ApplicationController

  layout 'admin/events'

  before_action :authenticate_admin!
  before_action :set_session_nil, if: :admin_signed_in?
  before_action :set_user, only: [:enable, :disable]

  def index
    respond_to do |format|
      format.html { @users = User.enabled.paginate(:page => params[:page], :per_page => 5) }
      format.js do
        if enabled?
          @users = User.enabled.paginate(:page => params[:page], :per_page => 5)
        else
          @users = User.disabled.paginate(:page => params[:page], :per_page => 5)
        end  
      end
    end
  end


  def enable
    if @user.update(:enabled => true)
      redirect_to admin_users_url, notice: "#{ @user.name } successfully enabled "
    else
      redirect_to admin_users_url, alert: "Failed to enable #{ @user.name }"
    end
  end

  def disable
    if @user.update(:enabled => false)
      redirect_to admin_users_url, notice: "#{ @user.name } successfully disabled "
    else
      redirect_to admin_users_url, alert: "Failed to disable #{ @user.name }"
    end
  end

  private

    def enabled?
      params[:user][:filter] == 'enabled'
    end

    def set_user
      @user = User.where(id: params[:id]).first
      if @user.nil?
        redirect_to users_url, alert: 'User not found'
      end  
    end

end