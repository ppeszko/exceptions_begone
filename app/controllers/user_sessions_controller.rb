class UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    cookies[:current_user] = params[:user_session][:username]
    flash[:notice] = "Logged in"
    redirect_to root_url
  end
  
  def destroy
    cookies.delete :current_user
    flash[:notice] = "Logged out"
    redirect_to root_url
  end
end
