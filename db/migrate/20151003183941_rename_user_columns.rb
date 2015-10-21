class RenameUserColumns < ActiveRecord::Migration
  def change
    rename_column :users, :firstname, :first_name
    rename_column :users, :lastname, :last_name
  end
end
