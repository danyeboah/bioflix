class ReviewsController < ApplicationController
  before_action :require_user
  before_action :find_video
  before_action :find_review, except: [:create]

  def create    
    # prevent multiple reviews from the same user
    if @video.reviews.map(&:user_id).include?(current_user.id)
      flash['danger'] = "You have previously already submitted a review. Edit your old review"
      redirect_to video_path(@video)
      return
    end

    @review = @video.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      flash["success"] = "Review was successfully created"
      redirect_to video_path(@video)
    else
      flash.now["danger"] = "There was a problem saving your review"
      render 'videos/show'
    end
  end

  def edit;end

  def update
    if @review.update(review_params)
      flash["success"] = "Review was successfully edited"
      redirect_to video_path(@video)
    else
      flash.now["danger"] = "There was a problem updating your review"
      render 'videos/show'
    end
  end

  def destroy
    if @review.destroy 
      flash['success'] = "Review was successfully deleted"
    else
      flash['danger'] = "There was an error deleting your review. Try again"
    end

    redirect_to video_path(@video)
  end

  private
  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def find_video
    @video = Video.find_by(slug: params[:video_id])
  end

  def find_review
    @review = Review.find(params[:id])
  end
end
