class RemoveRatingFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :rating, :float
  end
end
