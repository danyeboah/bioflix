class Video < ActiveRecord::Base
  include Slug

  validates_presence_of :title, :description
  belongs_to :category, foreign_key: :category_id

  sluggable_column :title

  before_save :generate_slug


  def self.search_by_title(title)
    where("lower(title) LIKE ?", "%#{title.downcase}%").order("title ASC  ")
  end
end
