class Car < ApplicationRecord
  include AASM
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations, dependent: :destroy
  has_many :car_status_histories, dependent: :destroy

  validates :name, presence: true, length: { in: 4..250 }
  validates :model, presence: true, length: { in: 4..250 }
  validates :image, presence: true, length: { in: 4..250 }, uniqueness: true
  validates :daily_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { in: 5..500 }
  validates :status, presence: true

  attr_accessor :current_user

  after_commit :log_status_change, if: :saved_change_to_status?

  aasm column: 'status' do
    state :available, initial: true
    state :reserved , :maintenance, :retired
    
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
                  guard: :no_pending_reservations?
    end
  end
  
  private

  def no_pending_reservations?
    reservations.where("dropoff_date > ?", Date.today).empty?
  end

  def log_status_change
    from = aasm.from_state || status_was
    to = aasm.to_state || status

    return if from == to 

    car_status_histories.create!(
      user: current_user,
      from_status: from,
      to_status: to,
      notes: "Status changed by #{current_user&.email || 'System'}"
    )
  end
end
