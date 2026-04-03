require 'rails_helper'

RSpec.describe ReservationConfirmationJob, type: :job do
  # Use the built-in ActiveJob queue adapter for testing
  include ActiveJob::TestHelper

  let!(:user) { User.create!(name: 'Abel', email: 'abel@test.com', password: 'password') }
  let!(:car) { Car.create!(name: 'BMW 3 Series', model: '2021', daily_price: 100, image: 'bmw.jpg', description: 'A BMW') }

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
      expect {
        ReservationConfirmationJob.perform_later(reservation.id)
      }.to have_enqueued_job(ReservationConfirmationJob)
        .with(reservation.id)
        .on_queue('default')
    end
  end

  describe '#perform' do
    it 'finds the reservation and calls the Mailer' do
      mailer_double = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
      
      expect(ReservationMailer).to receive(:confirmation_email)
        .with(reservation)
        .and_return(mailer_double)

      ReservationConfirmationJob.new.perform(reservation.id)
    end

    it 'logs an error if the reservation is not found' do
      expect(Rails.logger).to receive(:error).with(/Reservation not found/)
      
      ReservationConfirmationJob.new.perform(999_999)
    end
  end
end