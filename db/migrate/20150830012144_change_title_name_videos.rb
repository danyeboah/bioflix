class ChangeTitleNameVideos < ActiveRecord::Migration
  def change
    rename_column :videos, :Title, :title
    rename_column :videos, :Description, :description
  end
end
