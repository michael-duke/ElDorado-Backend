require 'rails_helper'

RSpec.describe ReservationMailer do
  let(:user) { User.create(name: 'Abel', email: 'abel@test.com', password: 'password') }
  let(:car) do
    Car.create(name: 'Tesla Model 3', model: '2024', daily_price: 200, image: 'tesla.jpg', description: 'Electric')
  end
  let(:reservation) do
    Reservation.create(user: user, car: car, pickup_date: Date.tomorrow, dropoff_date: Date.tomorrow + 2.days)
  end

  describe 'confirmation_email' do
    let(:mail) { described_class.confirmation_email(reservation) }

    it 'renders the headers with a dynamic subject', :aggregate_failures do
      expect(mail.subject).to eq("Reservation Confirmed: Your #{car.name} is ready!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@eldorado-rentals.com'])
    end

    it 'renders the body with specific car details', :aggregate_failures do
      # Ensure the car name appears in the body too
      expect(mail.body.encoded).to include(car.name)
      expect(mail.body.encoded).to include("Pickup: #{reservation.pickup_date}")
    end
  end
end
