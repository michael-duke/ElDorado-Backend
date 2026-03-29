require 'rails_helper'

RSpec.describe CarStatusHistory, type: :model do
  let(:user) { User.create(name: 'Admin', email: 'admin@test.com', password: 'password') }
  let(:car) { Car.create(name: 'Tesla Model 3', model: '2024', daily_price: 200, image: 'tesla.jpg', description: 'Electric car') }
  
  # A valid log entry
  let(:log) { 
    CarStatusHistory.new(
      car: car, 
      user: user, 
      from_status: 'available', 
      to_status: 'reserved', 
      notes: 'Manual reservation'
    ) 
  }

  context 'Testing Validations' do
    it 'is valid with all attributes' do
      expect(log).to be_valid
    end

    it 'is invalid without a car' do
      log.car = nil
      expect(log).to_not be_valid
    end

    it 'is invalid without a from_status' do
      log.from_status = nil
      expect(log).to_not be_valid
    end

    it 'is invalid without a to_status' do
      log.to_status = nil
      expect(log).to_not be_valid
    end

    it 'is valid WITHOUT a user (System Action)' do
      # This is crucial for your lambda ->(user = nil) logic
      log.user = nil
      expect(log).to be_valid
    end
  end

  context 'Testing Associations' do
    it 'belongs_to a car' do
      assoc = CarStatusHistory.reflect_on_association(:car)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs_to a user' do
      assoc = CarStatusHistory.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end