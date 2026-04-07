class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { in: 1..50 }, uniqueness: true
  validates :password, presence: true, length: { in: 6..20 }

  has_many :reservations, dependent: :destroy
  has_many :cars, through: :reservations, dependent: :destroy
  has_many :car_status_histories

  # 0: customer, 1: admin
  enum role: { customer: 0, admin: 1 }
end
