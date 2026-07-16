class Admin::ReviewsController < Admin::BaseController
  before_action :set_review, only: [:approve, :reject, :destroy]

  def index
    @reviews = Review.includes(:user, :product).recent.page(params[:page]).per(10)
  end

  def approve
    authorize @review, :approve?
    @review.update!(status: "approved")
    redirect_to admin_reviews_path, notice: "Review approved successfully."
  end

  def reject
    authorize @review, :reject?
    @review.update!(status: "rejected")
    redirect_to admin_reviews_path, notice: "Review rejected successfully."
  end

  def destroy
    authorize @review
    @review.destroy
    redirect_to admin_reviews_path, notice: "Review deleted successfully."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end
end
