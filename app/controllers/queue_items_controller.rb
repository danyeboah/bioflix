class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    # check to see if already in queue
    already_in_queue = current_user.queue_items.any? {|item| item.video_id == params[:video_id].to_i} 
    queue_item = current_user.queue_items.new(video_id: params[:video_id], position: current_user.queue_items.size + 1)

    if already_in_queue
      flash['error'] = "Video already exists in your queue"
    elsif (!already_in_queue) 
      queue_item.save
    else
      flash['error'] = "There was a problem adding this video to the queue"
    end
    redirect_to user_queue_items_path(current_user)
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    redirect_to user_queue_items_path(current_user)
  end

end
