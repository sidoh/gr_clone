class AddIsReadToFeedItem < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :is_read, :boolean
  end

  def self.down
    remove_column :feed_items, :is_read
  end
end
