class Coupon < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_type, presence: true, inclusion: { in: %w[percentage flat free_shipping] }
  validates :discount_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :min_order_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :usage_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :expiry_date_cannot_be_in_the_past, on: :create

  scope :active, -> { where(active: true).where("expiry_date IS NULL OR expiry_date >= ?", Time.current) }

  def valid_for?(amount)
    return false unless active
    return false if expired?
    return false if usage_limit_reached?
    return false if amount < min_order_amount
    true
  end

  def expired?
    expiry_date.present? && expiry_date < Time.current
  end

  def usage_limit_reached?
    usage_limit.present? && usage_count >= usage_limit
  end

  def calculate_discount(subtotal)
    case discount_type
    when "percentage"
      (subtotal * discount_value / 100.0).round(2)
    when "flat"
      [discount_value, subtotal].min
    when "free_shipping"
      0.0 # Handled externally in order shipping calculations
    else
      0.0
    end
  end

  private

  def expiry_date_cannot_be_in_the_past
    if expiry_date.present? && expiry_date < Time.current
      errors.add(:expiry_date, "cannot be in the past")
    end
  end
end
