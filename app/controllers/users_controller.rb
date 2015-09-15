class UsersController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)     
    if @user.save
      flash["notice"] = "Your account has been created" #///////////// change flash
      redirect_to login_path
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit!
  end
end
