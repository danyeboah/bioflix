class FriendshipsController < ApplicationController
  before_action :require_user
  def index;end

  def create
    leader = User.find(params[:leader_id])
    if current_user.id == params[:leader_id].to_i
      flash["danger"] = "You can't follow yourself"
      redirect_to user_path(current_user)
      return
    elsif current_user.follows?(leader)
      flash["danger"] = "You are already following #{leader.first_name}"
      redirect_to user_friendships_path(current_user)
      return
    else
      newfriends = Friendship.new(leader_id: params[:leader_id], follower_id: current_user.id) 
    end 

    if newfriends.save
      flash["success"] = "You are now following #{newfriends.leader.first_name}"
    else
      flash["danger"] = "There was an error following #{User.find(params[:leader_id])}"
    end

    redirect_to user_friendships_path(current_user)
  end

  def destroy
    relationship = Friendship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to user_friendships_path(current_user)
  end
end