class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :car

  # Standard Validations
  validates :car_id, presence: true
  validates :user_id, presence: true
  
  # Business Logic: One user shouldn't book the same car twice at the same time
  validates :car_id, uniqueness: { scope: :user_id, message: 'has already been booked by you' }

  # Date Validations
  validates :pickup_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }
  validates :dropoff_date, presence: true,
                          comparison: { greater_than: :pickup_date,
                                        message: 'must be at least 1 day after pickup date' }

  validate :car_not_already_booked
  validate :pickup_date_cannot_be_in_the_past

  private 

  def pickup_date_cannot_be_in_the_past
    if pickup_date.present? && pickup_date < Date.current
      errors.add(:pickup_date, "must be today or later")
    end
  end

  def car_not_already_booked
    return if pickup_date.blank? || dropoff_date.blank?

    overlapping = Reservation.where(car_id: car_id)
                            .where.not(id: id)
                            .where("pickup_date < ? AND dropoff_date > ?", dropoff_date, pickup_date)

    if overlapping.exists?
      errors.add(:base, "This car is already reserved for these dates.")
    end
  end
end