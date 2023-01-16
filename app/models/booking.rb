class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :car_id, presence: true, uniqueness: { scope: :user_id, message: 'You have already booked this car' }
  validates :user_id, presence: true
  validates :return_date, comparison: { greater_than: :pickup_date }
  validates :pickup_date, presence: true,
                          comparison: { greater_than_or_equal_to: Date.today,
                                        message: 'Pickup date must be today or later' }
  validates :return_date, presence: true,
                          comparison: { greater_than: Date.today + 1.day,
                                        message: 'Return date must be at least 1 day after pickup date' }

  validate :car_not_owned_by_user
  validate :car_not_found

  private

  def car_not_owned_by_user
    errors.add(:car_id, 'You cannot book your own car') if car.present? && car.user == user
  end

  def car_not_found
    errors.add(:car_id, 'Car not found') if car.nil?
  end
end
