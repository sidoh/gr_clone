class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :feed_items, :dependent => :destroy

  # Fetches all RSS items associated with this feed and stores them if
  # they haven't been stored already.
  def fetch_and_store_items( parsed_rss = nil )
    if parsed_rss.nil?
      meta = Feed.fetch_meta_from_url(self.url)

      if ! meta[:error].nil?
        return { :error => meta[:error] }
      end

      parsed_rss = meta[:parsed]
    end

    parsed_rss.items.each do |item|
      if FeedItem.where(:link => item.link, :title => item.title).count == 0
        date = (defined? item.date) ? item.date : Time.now
        desc = item.description.gsub /<script/, ''

        self.feed_items.create! :title => item.title, :link => item.link,
          :description => desc, :user_id => user_id,
          :created_at => date.to_s
      end
    end
  end

  def unread_feed_items
    feed_items.where :is_read => false
  end

  def _css_id
    "feed-#{id}"
  end

  def self.fetch_meta_from_url(url)
    require 'open-uri'
    require 'rss/1.0'
    require 'rss/2.0'

    begin
      rss = RSS::Parser.parse(open(url))

      return {
          :url => url,
          :title => rss.channel.title,
          :parsed => rss
      }
    rescue Errno::ENOENT
      return { :error => 'Not a URL.' }
    rescue SocketError, Errno::ECONNREFUSED
      return { :error => 'Request failed.' }
    rescue OpenURI::HTTPError => e
      return { :error => "Error during request: #{e.message}" }
    rescue RSS::NotWellFormedError
      return { :error => 'Not an RSS feed.' }
    end
  end

  def self.user_feeds_with_url(user, url)
    Feed.where 'user_id = ? and url = ?', user.id, url
  end

  def self.create_from_url!(user, url)
    error = nil
    new = nil

    if Feed.user_feeds_with_url(user, url).count > 0
      error = 'You are already subscribed to this feed!'
    else
      meta  = Feed.fetch_meta_from_url(url)

      if meta[:error].nil?
        new = user.feeds.create! :url => meta[:url], :title => meta[:title]
        new.fetch_and_store_items(meta[:parsed])
      else
        error = meta[:error]
      end
    end

    return { :error => error } unless error.nil?
    return { :newly_created => new }
  end

  def self._css_totals_id
    "ix-feed-totals"
  end
end
