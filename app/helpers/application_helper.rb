module ApplicationHelper
  def rating_options(selected=nil)
    options_for_select([["1 star", 1.0],["2 stars", 2.0],["3 stars", 3.0],["4 stars", 4.0],["5 stars", 5.0]], selected)
  end

  def video_rating_by_user(video_id,user_id)
    review = Review.find_by_video_id_and_user_id(video_id,user_id)
    if review
      return review.rating
    else
      return nil
    end
  end
end
