require 'rails_helper'

RSpec.describe Booking, type: :model do
  before :each do
    @user = User.create(name: 'Abel.G', email: 'abcd@gmail.com', password: '123456')
    @car = Car.create(name: 'BMW 3 Series',
                      image: 'https://www.bmw.com/content/dam/bmw/common/all-models/3-series/sedan/2021/navigation/BMW-3-Series-Sedan-2021-Exterior-01.jpg/_jcr_content/renditions/cq5dam.resized.img.585.low.time1594732800000.jpg',
                      model: '2021',
                      daily_price: 150,
                      description: 'The BMW 3 Series is a compact executive car.')
    @booking = Booking.new(user: @user, car: @car, pickup_date: Date.today, return_date: Date.today + 4.day)
  end

  context 'Testing Validations' do
    it 'is valid with valid attributes' do
      @booking.save
      expect(@booking).to be_valid
    end

    it 'is invalid without user_id' do
      @booking.user_id = nil
      @booking.save
      expect(@booking).to_not be_valid
    end

    it 'is invalid without car_id' do
      @booking.car_id = nil
      @booking.save
      expect(@booking).to_not be_valid
    end

    it 'is invalid without a pickup date' do
      @booking.pickup_date = nil
      @booking.save
      expect(@booking).to_not be_valid
    end

    it 'is invalid without a return date' do
      @booking.return_date = nil
      @booking.save
      expect(@booking).to_not be_valid
    end

    it 'should not book car again' do
      @booking.save
      @booking_again = Booking.new(user: @user, car: @car, pickup_date: Date.today, return_date: Date.today + 4.day)
      expect(@booking_again).to_not be_valid
    end

    it 'is invalid for a pickup date before the current date' do
      @booking.pickup_date = '2000-01-05'
      @booking.save
      expect(@booking).to_not be_valid
    end

    it 'is invalid for the same pickup & return date' do
      @booking.pickup_date = '2023-01-05'
      @booking.return_date = '2023-01-05'
      @booking.save
      expect(@booking).to_not be_valid
    end

    it 'is invalid for the return date to be the same as current date' do
      @booking.return_date = Date.today
      @booking.save
      expect(@booking).to_not be_valid
    end
  end

  context 'Testing Associations' do
    it 'belongs_to a user' do
      assoc = Booking.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs_to a car' do
      assoc = Booking.reflect_on_association(:car)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
