class Address < ApplicationRecord
  belongs_to :user, optional: true

  validates :address_type, presence: true, inclusion: { in: %w[shipping billing] }
  validates :full_name, presence: true
  validates :address_line1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :country, presence: true
  validates :phone, presence: true

  def one_line_summary
    [address_line1, address_line2, city, state, zip_code, country].reject(&:blank?).join(", ")
  end
end
