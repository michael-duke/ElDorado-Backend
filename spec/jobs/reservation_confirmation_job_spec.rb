require 'rails_helper'

RSpec.describe ReservationConfirmationJob do
  include ActiveJob::TestHelper

  let!(:user) { User.create!(name: 'Abel', email: 'abel@test.com', password: 'password') }
  let!(:car) do
    Car.create!(name: 'BMW 3 Series', model: '2021', daily_price: 100, image: 'bmw.jpg', description: 'A BMW')
  end

  let!(:reservation) do
    Reservation.create!(
      user: user,
      car: car,
      pickup_date: Date.current + 10.days,
      dropoff_date: Date.current + 12.days
    )
  end

  describe '#perform_later' do
    it 'queues the job correctly' do
      expect do
        described_class.perform_later(reservation.id)
      end.to have_enqueued_job(described_class)
        .with(reservation.id)
        .on_queue('default')
    end
  end

  describe '#perform' do
    it 'finds the reservation and calls the Mailer' do
      mailer_double = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
      allow(ReservationMailer).to receive(:confirmation_email).and_return(mailer_double)

      described_class.new.perform(reservation.id)

      expect(ReservationMailer).to have_received(:confirmation_email).with(reservation)
    end

    it 'logs an error if the reservation is not found' do
      allow(Rails.logger).to receive(:error)

      described_class.new.perform(999_999)

      expect(Rails.logger).to have_received(:error).with(/Reservation not found/)
    end
  end
end
