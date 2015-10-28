class QueueItem < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id
  belongs_to :video, foreign_key: :video_id

  validates_numericality_of :position, {only_integer: true}

  def rating
    review = find_review
    review.rating if review
  end

  def rating=(new_rating)
    review = find_review
    if review
      review.update_column(:rating, new_rating) 
    else
      new_review = Review.new(rating: new_rating, user_id: self.user.id, video_id: self.video.id)
      new_review.save(validate: false)
    end
  end

  private
  def find_review
    review = Review.find_by(user_id: self.user_id, video_id: self.video_id)
  end
end
