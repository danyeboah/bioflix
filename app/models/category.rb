class Category < ActiveRecord::Base
  include Slug
  has_many :videos, foreign_key: :category_id
  sluggable_column :name

  before_save :generate_slug


  def recent_videos(number)
    ordered_videos = videos.order(created_at: :desc).first(number)
  end
end