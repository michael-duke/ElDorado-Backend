require 'rails_helper'

RSpec.describe Reservation do
  let(:user) do
    User.create(name: 'Abel.G', email: 'abcd@gmail.com', password: '123456')
  end
  let(:car) do
    Car.create(name: 'BMW 3 Series', model: '2021', daily_price: 150,
               description: 'Compact executive car.', image: 'https://example.com/bmw.jpg')
  end

  let(:valid_reservation) do
    described_class.new(user: user, car: car,
                        pickup_date: Date.tomorrow, dropoff_date: Date.tomorrow + 4.days)
  end

  context 'when testing validations' do
    it 'is valid with valid attributes' do
      expect(valid_reservation).to be_valid
    end

    it 'is invalid without user_id' do
      valid_reservation.user = nil
      expect(valid_reservation).not_to be_valid
    end

    it 'is invalid without a pickup date' do
      valid_reservation.pickup_date = nil
      expect(valid_reservation).not_to be_valid
    end

    it 'is invalid without a dropoff date' do
      valid_reservation.dropoff_date = nil
      expect(valid_reservation).not_to be_valid
    end

    it 'is invalid if pickup date is in the past' do
      valid_reservation.pickup_date = Date.yesterday
      expect(valid_reservation).not_to be_valid
    end

    it 'is invalid if dropoff is same as pickup' do
      valid_reservation.dropoff_date = valid_reservation.pickup_date
      expect(valid_reservation).not_to be_valid
    end
  end

  context 'when dates overlap (The "No-Go Zone")' do
    before { valid_reservation.save! }

    it 'blocks a new reservation that is exactly the same dates' do
      duplicate = described_class.new(user: user, car: car, pickup_date: valid_reservation.pickup_date,
                                      dropoff_date: valid_reservation.dropoff_date)
      expect(duplicate).not_to be_valid
    end

    it 'blocks a reservation that "Sandwiches" the existing one' do
      # Existing: Tomorrow to +4 days. New: Today to +10 days.
      sandwich = described_class.new(user: user, car: car, pickup_date: Time.zone.today,
                                     dropoff_date: Time.zone.today + 10.days)
      expect(sandwich).not_to be_valid
    end

    it 'blocks a reservation that overlaps the end boundary' do
      # Existing: March 10-15. New: March 14-18.
      overlap_end = described_class.new(user: user, car: car, pickup_date: valid_reservation.dropoff_date - 1.day,
                                        dropoff_date: valid_reservation.dropoff_date + 2.days)
      expect(overlap_end).not_to be_valid
    end
  end

  context 'with associations' do
    it 'belongs_to a user' do
      expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'belongs_to a car' do
      expect(described_class.reflect_on_association(:car).macro).to eq :belongs_to
    end
  end
end
