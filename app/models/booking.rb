class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :car_id, presence: true, uniqueness: { scope: :user_id, message: 'has already been booked' }
  validates :user_id, presence: true
  validates :return_date, comparison: { greater_than: :pickup_date }
  validates :pickup_date, presence: true,
                          comparison: { greater_than_or_equal_to: Date.today,
                                        message: 'must be today or later' }
  validates :return_date, presence: true,
                          comparison: { greater_than: Date.today,
                                        message: 'must be at least 1 day after pickup date' }

  validate :car_not_owned_by_user
  validate :car_not_found

  private

  def car_not_owned_by_user
    errors.add(:car_id, 'cannot be booked by the same owner') if car.present? && car.user == user
  end

  def car_not_found
    errors.add(:car_id, 'not found') if car.nil?
  end
end
