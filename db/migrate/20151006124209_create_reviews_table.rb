class CreateReviewsTable < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :content
      t.float :rating
    end
  end
end
