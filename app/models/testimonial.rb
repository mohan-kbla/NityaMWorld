class Testimonial < ApplicationRecord
  has_one_attached :image

  validates :author_name, presence: true
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }

  scope :active, -> { where(active: true) }
end
