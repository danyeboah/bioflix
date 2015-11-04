class CreateFriendship < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :leader_id
      t.integer :follower_id
      t.timestamps
    end
  end
end
