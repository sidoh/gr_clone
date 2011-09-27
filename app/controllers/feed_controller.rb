class FeedController < ApplicationController
  include FeedHelper
  before_filter :authenticate_user!

  def index
    @feeds = current_user.feeds
    @items = current_user.feed_items

    respond_to do |format|
      format.html
    end
  end

  def show
    @items = current_user.feeds.find(params[:id]).feed_items.recent

    respond_to do |format|
      format.js
    end
  end

  def new
    url = params[:feed_url]
    res = Feed.create_from_url!(current_user, url)

    if res[:error].nil?
      render :partial => 'feed_list.html.haml',
             :locals => { :feeds => current_user.feeds, :newly_created => res[:newly_created] }
    else
      render :json => res
    end
  end

  def refresh_all
    current_user.feeds.each do |feed|
      feed.fetch_and_store_items
    end
  end
end
