class CarStatusHistory < ApplicationRecord
  belongs_to :car
  belongs_to :user, optional: true

  validates :from_status, :to_status, presence: true
end
