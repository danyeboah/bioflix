require 'spec_helper'

describe QueueItem do
  it {should belong_to(:video)}
  it {should belong_to(:user)}
  it {should validate_numericality_of(:position)}

  let!(:user1) {Fabricate(:user)}
  let!(:video1) {Fabricate(:video)}
    
  let!(:user2) {Fabricate(:user)}
  let!(:video2) {Fabricate(:video)}

  let!(:review1) {Fabricate(:review, rating: 1, user: user1, video: video1)}

  let!(:queue_item1) {Fabricate(:queue_item, user: user1, video: video1)}
  let!(:queue_item2) {Fabricate(:queue_item, user: user2, video: video2)}


  describe "#rating" do
    it "returns the rating of the a specified user and video if present" do
      expect(queue_item1.rating).to eq(review1.rating)
    end

    it "returns nil if a review for the specific video and user is not present" do
      expect(queue_item2.rating).to eq(nil)
    end
  end


  describe "#rating=" do
    it "changes the rating of the review if review is present" do
      queue_item1.rating=(5)
      expect(queue_item1.reload.rating).to eq(5)
    end

    it "clears the rating of the review if review is present" do
      queue_item1.rating=(nil)
      expect(queue_item1.reload.rating).to eq(nil)
    end

    it "creates a new review if review is not present" do
      queue_item2.rating=(5)
      expect(queue_item2.reload.rating).to eq(5)
    end
  end
end
