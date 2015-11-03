require 'spec_helper'

describe User do
  it {should validate_presence_of(:first_name)}
  it {should validate_presence_of(:last_name)}
  it {should validate_presence_of(:email)} 
  it {should validate_uniqueness_of(:email)}  #### come back to fix this
  it {should validate_length_of(:password).on(:create)}
  it {should validate_presence_of(:password).on(:create)}
  it {should have_secure_password}
  it {should have_many(:reviews).order("created_at DESC")}
  it {should have_many(:queue_items).order("position")}
  it {should have_many(:following_relationships)}
  it {should have_many(:leading_relationships)}

  let!(:user2) {Fabricate(:user, first_name: "Jane", last_name: "Doe")}
  let!(:user3) {Fabricate(:user)}
  let!(:user4) {Fabricate(:user)}
  let!(:user5) {Fabricate(:user)}
  let!(:user6) {Fabricate(:user)}
    
  let!(:friendship1) {Fabricate(:friendship, leader: user3, follower: user2)}

  describe "#video_in_user_queue?" do
    it "returns true if video is in the users queue" do
      user1 = Fabricate(:user)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      video3 = Fabricate(:video)

      queue_item1 = Fabricate(:queue_item, user: user1, video: video1)
      queue_item2 = Fabricate(:queue_item, user: user1, video: video2)
      queue_item3 = Fabricate(:queue_item, user: user1, video: video3)

      expect(user1.video_in_user_queue?(video2.id)).to be true
    end
  end

  describe "#follows?" do
    it "returns true if user is following other user" do
      expect(user2.follows?(user3)).to be true
    end
  end

  describe "#can_follow?" do
    it "returns false if user is current user" do
      expect(user2.can_follow?(user2)).to be false
    end

    it "returns false if user is already following other user" do
      expect(user2.can_follow?(user3)).to be false
    end
  end

  describe "#full_name" do
    it "returns user's full name" do
      expect(user2.full_name).to eq("Jane Doe")
    end
  end

  describe "#self.random_users" do
    it "returns 5 random users" do
      expect(User.random_users).to match_array([user2,user3,user4,user5,user6])
    end
  end
end
