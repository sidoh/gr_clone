class AddDefaultValueToIsReadInFeedItems < ActiveRecord::Migration
  def self.up
    change_column_default(:feed_items, :is_read, false)
  end

  def self.down
    change_column_default(:feed_items, :is_read, nil)
  end
end
