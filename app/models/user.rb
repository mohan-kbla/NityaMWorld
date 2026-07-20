class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :orders
  has_many :addresses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :wishlists, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true

  # Role helpers
  def admin?
    role == "admin"
  end

  def staff?
    role == "staff"
  end

  def customer?
    role == "customer"
  end

  # Ransack search setup
  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "phone", "role", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders", "addresses", "reviews", "wishlists"]
  end
end
