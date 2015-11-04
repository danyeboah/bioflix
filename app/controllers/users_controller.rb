class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      flash["success"] = "Your account has been created"
      AppMailer.send_welcome_mail(@user).deliver
      cookies.signed[:auth_token] = @user.auth_token 
      redirect_to videos_path
    else
      render :new
    end
  end

  def show
    @user = User.find_by(slug: params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:first_name,:last_name,:email,:password,:password_confirmation)
  end
end
