require 'rails_helper'

RSpec.describe CarStatusHistory do
  let(:user) { User.create(name: 'Admin', email: 'admin@test.com', password: 'password') }
  let(:car) do
    Car.create(name: 'Tesla Model 3', model: '2024', daily_price: 200, image: 'tesla.jpg', description: 'Electric car')
  end

  # A valid log entry
  let(:log) do
    described_class.new(
      car: car,
      user: user,
      from_status: 'available',
      to_status: 'reserved',
      notes: 'Manual reservation'
    )
  end

  context 'when testing validations' do
    it 'is valid with all attributes' do
      expect(log).to be_valid
    end

    it 'is invalid without a car' do
      log.car = nil
      expect(log).not_to be_valid
    end

    it 'is invalid without a from_status' do
      log.from_status = nil
      expect(log).not_to be_valid
    end

    it 'is invalid without a to_status' do
      log.to_status = nil
      expect(log).not_to be_valid
    end

    it 'is valid WITHOUT a user (System Action)' do
      # This is crucial for your lambda ->(user = nil) logic
      log.user = nil
      expect(log).to be_valid
    end
  end

  context 'with associations' do
    it 'belongs_to a car' do
      assoc = described_class.reflect_on_association(:car)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs_to a user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
