class FeedItemController < ApplicationController
  def mark_read
    css_id = params[:id]
    item   = FeedItem.find_by_css_id(css_id)

    if item.user_id == current_user.id
      item.is_read = true
      item.save!

      render :json => item.feed.user.get_unread_counts
    else
      render :json => false
    end
  end
end
