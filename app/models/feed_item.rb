class FeedItem < ActiveRecord::Base
  belongs_to :feed

  scope :recent, order('created_at DESC').limit(50)

  def user
    User.find user_id
  end

  def print_time
    if created_at.to_date == Time.now.to_date
      created_at.strftime "%H:%M"
    else
      created_at.strftime "%m/%d/%Y"
    end
  end

  def _css_read_class
    (is_read?) ? '' : 'unread'
  end

  def _css_id
    "ix-feed-item-#{id}"
  end

  def self.find_by_css_id(css_id)
    m = css_id.match /-([0-9]+)$/

    if m.nil?
      raise ArgumentError, "Invalid CSS ID: #{css_id}"
    else
      return FeedItem.find m[1]
    end
  end
end
