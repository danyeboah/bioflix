class Video < ActiveRecord::Base
  include Slug

  validates_presence_of :title, :description
  belongs_to :category, foreign_key: :category_id
  has_many :reviews, -> {order 'created_at DESC'}, foreign_key: :video_id
  sluggable_column :title

  before_create :generate_slug

  has_many :queue_items, foreign_key: :video_id

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(title)
    where("title ILIKE ?", "%#{title}%").order("title ASC  ")
  end
end
