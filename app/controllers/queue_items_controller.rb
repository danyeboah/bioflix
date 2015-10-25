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
require 'pry'
  def update
    begin
      QueueItem.transaction do
        all_updates = params[:queue_items]
        all_updates.each do |update|
          queue_item = QueueItem.find(update[:id])
          if queue_item.user == current_user
            review = Review.find_by_video_id_and_user_id(queue_item.video.id,queue_item.user.id)

            if review
              review.rating = update[:rating]
              review.save!
            elsif update[:rating]
              queue_item.video.reviews.create(rating: update[:rating], user: queue_item.user)
            end

            queue_item.position = update[:position] 
            queue_item.save! 
          end
        end
      end      
    rescue ActiveRecord::RecordInvalid
      flash['danger'] = "Input position or rating is not valid. Please try again"
      redirect_to user_queue_items_path(current_user)
      return
    end
 
    current_user.reorder
    redirect_to user_queue_items_path(current_user)
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    
    #update position numbers
    current_user.reorder
    redirect_to user_queue_items_path(current_user)
  end


end
