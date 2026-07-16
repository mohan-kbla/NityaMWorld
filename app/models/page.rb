class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  scope :active, -> { where(active: true) }
end
