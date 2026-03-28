class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :car

  # Standard Validations
  validates :car_id, presence: true
  validates :user_id, presence: true
  
  # Business Logic: One user shouldn't book the same car twice at the same time
  validates :car_id, uniqueness: { scope: :user_id, message: 'has already been booked by you' }

  # Date Validations
  validates :pickup_date, presence: true,
                         comparison: { greater_than_or_equal_to: Date.today,
                                       message: 'must be today or later' }
  validates :dropoff_date, presence: true,
                          comparison: { greater_than: :pickup_date,
                                        message: 'must be at least 1 day after pickup date' }

  # State Cleanup
  after_destroy :release_car

  private

  def release_car
    car.return!(user) if car.reserved?
  end
end