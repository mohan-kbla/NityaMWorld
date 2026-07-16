class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_one_attached :image

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  scope :published, -> { where("published_at IS NOT NULL AND published_at <= ?", Time.current) }
  scope :recent, -> { order(published_at: :desc) }

  def published?
    published_at.present? && published_at <= Time.current
  end
end
