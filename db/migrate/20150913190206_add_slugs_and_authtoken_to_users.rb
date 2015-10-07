class AddSlugsAndAuthtokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :users, :auth_token, :string
  end
end
