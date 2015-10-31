require 'spec_helper'

describe User do
  it {should validate_presence_of(:first_name)}
  it {should validate_presence_of(:last_name)}
  it {should validate_presence_of(:email)} 
  it {should validate_uniqueness_of(:email)}  #### come back to fix this
  it {should validate_length_of(:password).on(:create)}
  it {should validate_presence_of(:password).on(:create)}
  it {should have_secure_password}
  it {should have_many(:reviews)}
  it {should have_many(:queue_items).order("position")}

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

end
