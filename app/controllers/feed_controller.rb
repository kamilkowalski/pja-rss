class FeedController < ApplicationController
  def index
    @articles = Article.order("published_at DESC")

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end
end
