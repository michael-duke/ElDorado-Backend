class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { in: 1..50 }, uniqueness: true
  validates :password, presence: true, length: { in: 6..20 }

  # has_many :cars, dependent: :destroy
  # has_many :bookings, dependent: :destroy
end
