class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :Title
      t.text :Description
      t.string :small_cover_url
      t.string :large_cover_url

      t.timestamps
    end
  end
end
