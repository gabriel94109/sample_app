class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :text
    add_column :users, :website, :text
    add_column :users, :bio, :text
  end

  def self.down
    remove_column :users, :bio
    remove_column :users, :website
    remove_column :users, :location
  end
end
