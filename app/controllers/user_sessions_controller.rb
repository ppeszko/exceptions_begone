class UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session], :remember_me => params[:user_session][:remember_me] == "1")
    if @user_session.save
      flash[:notice] = "Logged in"
      redirect_to root_url
    else
      render :new
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Logged out"
    redirect_to root_url
  end
end
