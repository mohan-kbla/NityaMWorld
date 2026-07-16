class Admin::DashboardController < Admin::BaseController
  def index
    @total_orders = Order.count
    @total_revenue = Order.where.not(status: ["cancelled", "refunded"]).sum(:total_amount)
    @low_stock_products = Product.where("stock <= ?", 5)
    @recent_orders = Order.includes(:user).recent.limit(5)
    @recent_reviews = Review.includes(:user, :product).recent.limit(5)
    @pending_reviews_count = Review.pending.count
  end
end
