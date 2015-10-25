class QueueItem < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id
  belongs_to :video, foreign_key: :video_id

  validates_numericality_of :position, {only_integer: true}

end
