class User < ActiveRecord::Base
  include Slug
  sluggable_column :last_name
  before_save :generate_slug

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}, on: :create
  
  has_many :reviews, foreign_key: :user_id
  has_many :queue_items,-> {order 'position'}, foreign_key: :user_id

  has_secure_password

  before_save do 
    generate_token(:auth_token)
  end

  def video_in_user_queue(video_id)
    self.queue_items.pluck(:video_id).include?(video_id)
  end

  def reorder
    QueueItem.transaction do 
      self.queue_items.each_with_index do |item,index|
        item.position = index + 1
        item.save
      end
    end
  end

  # generate random token for login
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
