class VideosController < ApplicationController
  before_action :require_user
  def index
    @categories = Category.all 
  end

  def show
    @video = Video.find_by(slug: params[:id])
    @review_total = @video.reviews.count
    @rating_average = @video.reviews.average("rating") if @video.reviews
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:query])
  end

end
