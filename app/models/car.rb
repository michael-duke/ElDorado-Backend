class Car < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings, dependent: :destroy

  validates :name, presence: true, length: { in: 4..250 }
  validates :model, presence: true, length: { in: 4..250 }
  validates :image, presence: true, length: { in: 4..250 }, uniqueness: true
  validates :daily_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { in: 5..500 }
  validates :available, inclusion: { in: [true, false] }
end
