class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :car

  # Standard Validations

  # Business Logic: One user shouldn't book the same car twice at the same time
  validates :car_id, uniqueness: { scope: :user_id, message: :taken_by_user }

  # Date Validations
  validates :pickup_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }
  validates :dropoff_date, presence: true,
                           comparison: { greater_than: :pickup_date, message: :invalid_duration }

  validate :car_not_already_booked
  validate :pickup_date_cannot_be_in_the_past

  private

  def pickup_date_cannot_be_in_the_past
    return unless pickup_date.present? && pickup_date < Date.current

    errors.add(:pickup_date, 'must be today or later')
  end

  def car_not_already_booked
    return if pickup_date.blank? || dropoff_date.blank?

    overlapping = Reservation.where(car_id: car_id)
      .where.not(id: id)
      .where('pickup_date < ? AND dropoff_date > ?', dropoff_date, pickup_date)

    return unless overlapping.exists?

    errors.add(:base, 'This car is already reserved for these dates.')
  end
end
