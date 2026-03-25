require 'rails_helper'

RSpec.describe Reservation, type: :model do
  before :each do
    @user = User.create(name: 'Abel.G', email: 'abcd@gmail.com', password: '123456')
    @car = Car.create(name: 'BMW 3 Series',
                      image: 'https://www.bmw.com/content/dam/bmw/common/all-models/3-series/sedan/2021/navigation/BMW-3-Series-Sedan-2021-Exterior-01.jpg/_jcr_content/renditions/cq5dam.resized.img.585.low.time1594732800000.jpg',
                      model: '2021',
                      daily_price: 150,
                      description: 'The BMW 3 Series is a compact executive car.')
    @reservation = Reservation.new(user: @user, car: @car, pickup_date: Date.today, dropoff_date: Date.today + 4.day)
  end

  context 'Testing Validations' do
    it 'is valid with valid attributes' do
      @reservation.save
      expect(@reservation).to be_valid
    end

    it 'is invalid without user_id' do
      @reservation.user_id = nil
      @reservation.save
      expect(@reservation).to_not be_valid
    end

    it 'is invalid without car_id' do
      @reservation.car_id = nil
      @reservation.save
      expect(@reservation).to_not be_valid
    end

    it 'is invalid without a pickup date' do
      @reservation.pickup_date = nil
      @reservation.save
      expect(@reservation).to_not be_valid
    end

    it 'is invalid without a return date' do
      @reservation.dropoff_date = nil
      @reservation.save
      expect(@reservation).to_not be_valid
    end

    it 'should not reserve car again' do
      @reservation.save
      @reservation_again = Reservation.new(user: @user, car: @car, pickup_date: Date.today, dropoff_date: Date.today + 4.day)
      expect(@reservation_again).to_not be_valid
    end

    it 'is invalid for a pickup date before the current date' do
      @reservation.pickup_date = '2000-01-05'
      @reservation.save
      expect(@reservation).to_not be_valid
    end

    it 'is invalid for the same pickup & return date' do
      @reservation.pickup_date = '2023-01-05'
      @reservation.dropoff_date = '2023-01-05'
      @reservation.save
      expect(@reservation).to_not be_valid
    end

    it 'is invalid for the return date to be the same as current date' do
      @reservation.dropoff_date = Date.today
      @reservation.save
      expect(@reservation).to_not be_valid
    end
  end

  context 'Testing Associations' do
    it 'belongs_to a user' do
      assoc = Reservation.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs_to a car' do
      assoc = Reservation.reflect_on_association(:car)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
