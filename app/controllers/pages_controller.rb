class PagesController < ApplicationController
  def show
    @page = Page.active.friendly.find(params[:slug])
  end
end
