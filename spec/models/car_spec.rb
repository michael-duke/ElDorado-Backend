require 'rails_helper'

RSpec.describe Car do
  let(:user) { User.create(email: 'test@example.com', password: 'password', name: 'Tester') }

  let(:car) do
    described_class.create(
      name: 'Audi',
      image: 'https://www.audi.com/content/dam/gbp2/a4.jpg',
      model: '2021',
      daily_price: 100,
      description: 'A detailed description of the Audi A4 executive car.'
    )
  end

  before do
    car.current_user = user
  end

  context 'when passing wrong parameters to the method' do
    it 'does not save the car no name' do
      car.name = nil
      expect(car).not_to be_valid
    end

    it 'does not save the car no image' do
      car.image = nil
      expect(car).not_to be_valid
    end

    it 'does not save the car no model' do
      car.model = nil
      expect(car).not_to be_valid
    end

    it 'does not save the car no daily_price' do
      car.daily_price = nil
      expect(car).not_to be_valid
    end
  end

  context 'when passing valid parameters to the method' do
    it 'saves the car' do
      expect(car).to be_valid
    end
  end

  context 'when testing edge cases with the method' do
    it 'name should not exceed maximum length' do
      car.name = 'a' * 256
      expect(car).not_to be_valid
    end

    it 'name should not be less tham minimum length' do
      car.name = 'a'
      expect(car).not_to be_valid
    end

    it 'description should not be less tham minimum length' do
      car.description = 'a'
      expect(car).not_to be_valid
    end

    it 'image should not be less tham minimum length' do
      car.image = 'a'
      expect(car).not_to be_valid
    end
  end

  context 'when checking AASM States' do
    it 'starts in the available state' do
      expect(car.status).to eq('available')
    end

    it 'transitions from available to reserved' do
      car.reserve!
      expect(car.status).to eq('reserved')
    end

    it 'transitions from reserved back to available' do
      car.status = 'reserved'
      car.return!
      expect(car.status).to eq('available')
    end

    it 'transitions from reserved to maintenance' do
      car.status = 'reserved'
      car.repair!
      expect(car.status).to eq('maintenance')
    end

    it 'transitions from maintenance to available upon complete repair' do
      car.status = 'maintenance'
      car.repair_complete!
      expect(car.status).to eq('available')
    end

    it 'allows retirement if no pending reservations' do
      car.retire!
      expect(car.status).to eq('retired')
    end
  end

  context 'when there is a pending reservation' do
    before do
      Reservation.create!(
        user: user,
        car: car,
        pickup_date: Date.tomorrow,
        dropoff_date: Date.tomorrow + 4.days
      )
    end

    it 'raises an invalid transition error' do
      expect { car.retire! }.to raise_error(AASM::InvalidTransition)
    end

    it 'blocks retirement' do
      suppress(AASM::InvalidTransition) { car.retire! }
      expect(car.status).not_to eq('retired')
    end

    it 'remains in the available state' do
      suppress(AASM::InvalidTransition) { car.retire! }
      expect(car.status).to eq('available')
    end

    it 'prevents double-reserving (AASM State Guard)' do
      car.reserve!
      expect { car.reserve! }.to raise_error(AASM::InvalidTransition)
    end
  end

  context 'when checking audit logging' do
    before { car.reserve! }

    let(:log) { car.car_status_histories.last }

    it 'creates a CarStatusHistory record after a state transition' do
      expect(CarStatusHistory.count).to eq(1)
    end

    it 'logs the correct starting status' do
      expect(log.from_status).to eq('available')
    end

    it 'logs the correct target status' do
      expect(log.to_status).to eq('reserved')
    end
  end

  context 'with associations' do
    it 'has_many reservations' do
      assoc = described_class.reflect_on_association(:reservations)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many cars through reservations' do
      assoc = described_class.reflect_on_association(:users)
      expect(assoc.macro).to eq :has_many
    end

    it 'has_many car_status_histories' do
      assoc = described_class.reflect_on_association(:car_status_histories)
      expect(assoc.macro).to eq :has_many
    end
  end
end
