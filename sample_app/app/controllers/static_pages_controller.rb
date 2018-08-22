class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      if params[:search]
        @feed_items = Micropost.paginate(page: params[:page])
                      .where('content LIKE?',"%#{params[:search]}%")
        if @feed_items.count == 0
          flash[:info] = "Not find."
          @feed_items = current_user.feed.paginate(page: params[:page])
        end
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end