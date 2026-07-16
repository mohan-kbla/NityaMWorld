class BlogsController < ApplicationController
  def index
    @blogs = BlogPost.published.recent.page(params[:page]).per(9)
  end

  def show
    @blog = BlogPost.published.friendly.find(params[:slug])
  end
end
