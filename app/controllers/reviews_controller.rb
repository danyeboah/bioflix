class ReviewsController < ApplicationController
  before_action :require_user
  def create
    @video = Video.find_by(slug: params[:video_id])
    @review = @video.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      flash["success"] = "Review was successfully created"
      redirect_to video_path(@video)
    else
      flash["error"] = "There was a problem saving your review"
      render 'videos/show'
    end
  end

  private
  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
