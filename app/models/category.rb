class Category < ActiveRecord::Base
  include Slug
  has_many :videos, foreign_key: :category_id
  sluggable_column :name

  before_create :generate_slug

  validates :name, uniqueness: true


  def recent_videos(number)
    ordered_videos = videos.order(created_at: :desc).first(number)
  end
end