class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product, counter_cache: true

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :title, presence: true
  validates :body, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }

  scope :approved, -> { where(status: "approved") }
  scope :pending, -> { where(status: "pending") }
  scope :recent, -> { order(created_at: :desc) }

  after_save :update_product_average_rating, if: :saved_change_to_status?
  after_destroy :update_product_average_rating

  private

  def update_product_average_rating
    approved_reviews = product.reviews.approved
    avg_rating = approved_reviews.any? ? approved_reviews.average(:rating).to_f : 0.0
    product.update_columns(rating: avg_rating)
  end
end
