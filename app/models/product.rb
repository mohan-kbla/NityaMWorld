class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many_attached :images

  belongs_to :category
  belongs_to :brand

  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  has_many :wishlists, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discount_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :discount_price_must_be_less_than_price

  # Scopes
  scope :featured, -> { where(featured: true) }
  scope :best_sellers, -> { where(best_seller: true) }
  scope :new_arrivals, -> { where(new_arrival: true) }
  scope :in_stock, -> { where("stock > 0") }
  scope :out_of_stock, -> { where(stock: 0) }

  # Resolve selling price
  def active_price
    discount_price.present? && discount_price < price ? discount_price : price
  end

  def discounted?
    discount_price.present? && discount_price < price
  end

  def in_stock?
    stock > 0
  end

  # Ransack search configuration
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "slug", "sku", "price", "discount_price", "stock", "featured", "best_seller", "new_arrival", "rating", "created_at", "updated_at", "category_id", "brand_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "brand", "reviews"]
  end

  private

  def discount_price_must_be_less_than_price
    if discount_price.present? && price.present? && discount_price >= price
      errors.add(:discount_price, "must be less than the regular price")
    end
  end
end
