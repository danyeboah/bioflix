class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    # check to see if already in queue
    already_in_queue = current_user.queue_items.pluck(:video_id).include?(params[:video_id].to_i)
    queue_item = current_user.queue_items.new(video_id: params[:video_id], position: current_user.queue_items.size + 1)

    if already_in_queue
      flash['danger'] = "Video already exists in your queue"
    else
      queue_item.save
    end

    redirect_to user_queue_items_path(current_user)
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    redirect_to user_queue_items_path(current_user)
  end

end
