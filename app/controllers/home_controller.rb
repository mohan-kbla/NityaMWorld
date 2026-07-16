class HomeController < ApplicationController
  def index
    @banners = Banner.active.ordered
    @featured_categories = Category.where(parent_id: nil).limit(6)
    @featured_products = Product.where(featured: true).limit(8)
    @best_sellers = Product.where(best_seller: true).limit(8)
    @testimonials = Testimonial.active.limit(5)
  end
end
