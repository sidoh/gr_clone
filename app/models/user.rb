class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # A user has many RSS feeds
  has_many :feeds

  def unread_feed_items
    FeedItem.where :user_id => id, :is_read => false
  end

  def unread_feed_items_count
    FeedItem.count :user_id => id, :is_read => false
  end

  def feed_items
    FeedItem.find_all_by_user_id( id, :order => 'created_at DESC' )
  end

  def get_unread_counts
    counts = {}
    total  = 0
    feeds.each do |feed|
      c = feed.unread_feed_items.count

      counts[feed._css_id] = c
      total               += c
    end
    counts[Feed._css_totals_id] = total

    counts
  end
end
