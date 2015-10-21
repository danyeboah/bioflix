class Video < ActiveRecord::Base
  include Slug

  validates_presence_of :title, :description
  belongs_to :category, foreign_key: :category_id
  has_many :reviews, -> {order 'created_at DESC'}, foreign_key: :video_id
  sluggable_column :title

  before_save :generate_slug

  has_many :queue_items, foreign_key: :video_id


  def self.search_by_title(title)
    where("title ILIKE ?", "%#{title}%").order("title ASC  ")
  end
end
