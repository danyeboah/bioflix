class User < ActiveRecord::Base
  include Slug
  sluggable_column :lastname
  before_save :generate_slug

  validates_presence_of :firstname
  validates_presence_of :lastname

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}, on: :create


  has_secure_password


  before_save do 
    generate_token(:auth_token)
  end

  # generate random token for login
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column == self[column])
  end

end
