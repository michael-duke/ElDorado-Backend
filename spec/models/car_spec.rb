require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password', name: 'Tester') }

  before(:each) do
    @car = Car.create(
      name: 'Audi',
      image: 'https://www.audi.com/content/dam/gbp2/a4.jpg',
      model: '2021',
      daily_price: 100,
      description: 'A detailed description of the Audi A4 executive car.'
    )
  end

  context 'When passing wrong parameters to the method' do
    it 'should not save the car no name' do
      @car.name = nil
      expect(@car).to_not be_valid
    end

    it 'should not save the car no image' do
      @car.image = nil
      expect(@car).to_not be_valid
    end

    it 'should not save the car no model' do
      @car.model = nil
      expect(@car).to_not be_valid
    end

    it 'should not save the car no daily_price' do
      @car.daily_price = nil
      expect(@car).to_not be_valid
    end
  end

  context 'When passing valid parameters to the method' do
    it 'should save the car' do
      expect(@car).to be_valid
    end
  end

  context 'When testing edge cases with the method' do
    it 'name should not exceed maximum length' do
      @car.name = 'a'*256
      expect(@car).to_not be_valid
    end

    it 'name should not be less tham minimum length' do
      @car.name = 'a'
      expect(@car).to_not be_valid
    end

    it 'description should not be less tham minimum length' do
      @car.description = 'a'
      expect(@car).to_not be_valid
    end

    it 'image should not be less tham minimum length' do
      @car.image = 'a'
      expect(@car).to_not be_valid
    end
  end

  context 'Testing AASM States' do
    it 'should start in the available state' do
      expect(@car.status).to eq('available')
    end

    it 'transitions from available to reserved' do
      @car.reserve!(user)
      expect(@car.status).to eq('reserved')
    end

    it 'transitions from reserved back to available' do
      @car.status = 'reserved'
      @car.return!(user)
      expect(@car.status).to eq('available')
    end

    it 'raises an error if invalid transition is attempted' do
      # You can't "return" a car that is already "available"
      expect { @car.return!(user) }.to raise_error(AASM::InvalidTransition)
    end

    it 'prevents double-reserving (AASM State Guard)' do
      @car.reserve!(user)
      expect { @car.reserve!(user) }.to raise_error(AASM::InvalidTransition)
    end
  end

  context 'Testing Audit Logging' do
    it 'creates a CarStatusHistory record after a state transition' do
      expect { @car.reserve!(user) }.to change { CarStatusHistory.count }.by(1)
    end

    it 'logs the correct from and to states' do
      @car.reserve!(user)
      log = @car.car_status_histories.last
      expect(log.from_status).to eq('available')
      expect(log.to_status).to eq('reserved')
    end
  end

  context 'Testing Associations' do
    it 'has_many reservations' do
      assoc = Car.reflect_on_association(:reservations)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many cars through reservations' do
      assoc = Car.reflect_on_association(:users)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many car_status_histories' do
      assoc = Car.reflect_on_association(:car_status_histories)
      expect(assoc.macro).to eq :has_many
    end
  end
end
