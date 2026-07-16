class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    @review.status = "pending" # Force pending status for moderation

    if @review.save
      redirect_to shop_path(@review.product.slug), notice: "Your review has been submitted and is pending moderation."
    else
      redirect_to shop_path(@review.product.slug), alert: "Could not submit review: " + @review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :title, :body, :product_id)
  end
end
