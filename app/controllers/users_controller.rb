class UsersController < ApplicationController
  
  def index
    @users = User.all    
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
    render :new
  end
  
  def update
    @user = current_user
    @user.update_attributes(params[:user])
    if @user.save
      flash[:notice] = "Profil updated"
      redirect_to root_url
    else
      render :new
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful"
      redirect_to root_url
    else
      render :new
    end
  end
  
end
