class Car < ApplicationRecord
  include AASM
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations, dependent: :destroy

  validates :name, presence: true, length: { in: 4..250 }
  validates :model, presence: true, length: { in: 4..250 }
  validates :image, presence: true, length: { in: 4..250 }, uniqueness: true
  validates :daily_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { in: 5..500 }
  validates :status, presence: true

  aasm column: 'status' do
    state :available, initial: true
    state :reserved
    state :maintenance
    state :retired

    event :reserve do
      transitions from: :available, to: :reserved
    end

    event :return do
      transitions from: :reserved, to: :available
    end

    event :repair do
      transitions from: [:available, :reserved], to: :maintenance
    end

    event :repair_complete do
      transitions from: :maintenance, to: :available
    end

    event :retire do
      transitions from: [:available, :reserved, :maintenance], to: :retired, 
                  if: :no_pending_reservations?
    end
  end
  
  private

  def no_pending_reservations?
    reservations.where("dropoff_date > ?", Date.today).empty?
  end
end
