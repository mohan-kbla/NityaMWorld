class ShopController < ApplicationController
  def index
    sort_option = case params[:sort]
                  when "price_asc" then "price asc"
                  when "price_desc" then "price desc"
                  when "rating_desc" then "rating desc"
                  else "created_at desc"
                  end

    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true)
                  .includes(:category, :brand)
                  .order(sort_option)
                  .page(params[:page]).per(12)

    @brands = Brand.all
  end

  def show
    @product = Product.friendly.find(params[:slug])
    @approved_reviews = @product.reviews.approved.includes(:user).recent
    @new_review = Review.new(product: @product)
  end
end
