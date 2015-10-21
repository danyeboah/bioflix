class Review < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id
  belongs_to :video, foreign_key: :video_id

  validates :content, presence: true
  validates :rating, presence: true
end
