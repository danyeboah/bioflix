class SessionsController < ApplicationController
  def new
    redirect_to videos_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if(params[:remember_me]) == "1"
        cookies.permanent.signed[:auth_token] = user.auth_token
      else
        cookies.signed[:auth_token] = user.auth_token
      end

      flash["success"] = "You have been successfully logged in"
      redirect_to videos_path
    else 
      flash["error"] = "Username or password is invalid"
      redirect_to login_path
    end
  end

  def destroy
    cookies.delete(:auth_token)
    flash["notice"] = "You have successfully logged out"
    redirect_to root_path
  end


end