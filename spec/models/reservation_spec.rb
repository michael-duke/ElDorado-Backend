require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { 
    User.create(name: 'Abel.G', email: 'abcd@gmail.com', password: '123456') }
  let(:car) { 
    Car.create(name: 'BMW 3 Series', model: '2021', daily_price: 150, 
    description: 'Compact executive car.', image: 'https://example.com/bmw.jpg')}
  
  let(:valid_reservation) { 
    Reservation.new(user: user, car: car, 
    pickup_date: Date.tomorrow, dropoff_date: Date.tomorrow + 4.days) }
  
  context 'Testing Validations' do
    it 'is valid with valid attributes' do
      expect(valid_reservation).to be_valid
    end

    it 'is invalid without user_id' do
      valid_reservation.user = nil
      expect(valid_reservation).to_not be_valid
    end

    it 'is invalid without a pickup date' do
      valid_reservation.pickup_date = nil
      expect(valid_reservation).to_not be_valid
    end

    it 'is invalid without a dropoff date' do
      valid_reservation.dropoff_date = nil
      expect(valid_reservation).to_not be_valid
    end

    it 'is invalid if pickup date is in the past' do
      valid_reservation.pickup_date = Date.yesterday
      expect(valid_reservation).to_not be_valid
    end

    it 'is invalid if dropoff is same as pickup' do
      valid_reservation.dropoff_date = valid_reservation.pickup_date
      expect(valid_reservation).to_not be_valid
    end
  end

  context 'Testing Overlap Logic (The "No-Go Zone")' do
    before { valid_reservation.save! }

    it 'blocks a new reservation that is exactly the same dates' do
      duplicate = Reservation.new(user: user, car: car, pickup_date: valid_reservation.pickup_date, dropoff_date: valid_reservation.dropoff_date)
      expect(duplicate).to_not be_valid
    end

    it 'blocks a reservation that "Sandwiches" the existing one' do
      # Existing: Tomorrow to +4 days. New: Today to +10 days.
      sandwich = Reservation.new(user: user, car: car, pickup_date: Date.today, dropoff_date: Date.today + 10.days)
      expect(sandwich).to_not be_valid
    end

    it 'blocks a reservation that overlaps the end boundary' do
      # Existing: March 10-15. New: March 14-18.
      overlap_end = Reservation.new(user: user, car: car, pickup_date: valid_reservation.dropoff_date - 1.day, dropoff_date: valid_reservation.dropoff_date + 2.days)
      expect(overlap_end).to_not be_valid
    end
  end

  context 'Testing Associations' do
    it 'belongs_to a user' do
      expect(Reservation.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'belongs_to a car' do
      expect(Reservation.reflect_on_association(:car).macro).to eq :belongs_to
    end
  end
end
