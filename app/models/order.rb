class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :billing_address, class_name: "Address"

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: %w[pending confirmed packed shipped delivered cancelled refunded] }
  validates :payment_status, presence: true, inclusion: { in: %w[pending paid failed refunded] }
  validates :payment_method, presence: true, inclusion: { in: %w[razorpay cod] }
  validates :subtotal_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipping_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discount_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :pending, -> { where(status: "pending") }
  scope :confirmed, -> { where(status: "confirmed") }
  scope :shipped, -> { where(status: "shipped") }
  scope :delivered, -> { where(status: "delivered") }
  scope :cancelled, -> { where(status: "cancelled") }

  def tracking_url
    return nil if tracking_number.blank? || carrier.blank?
    case carrier.downcase
    when "dhl"
      "https://www.dhl.com/en/express/tracking.html?AWB=#{tracking_number}"
    when "fedex"
      "https://www.fedex.com/apps/fedextrack/?tracknumbers=#{tracking_number}"
    else
      nil
    end
  end

  # Ransack search setup
  def self.ransackable_attributes(auth_object = nil)
    ["id", "status", "payment_status", "payment_method", "total_amount", "subtotal_amount", "shipping_amount", "discount_amount", "tracking_number", "carrier", "notes", "created_at", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "shipping_address", "billing_address", "order_items", "products"]
  end
end
