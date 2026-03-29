require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake! # Prevents the job from actually running during the test

RSpec.describe ReservationConfirmationJob, type: :job do
  let!(:user) { User.create(name: 'Abel', email: 'abel@test.com', password: 'password') }
  let!(:car) { Car.create(name: 'BMW 3 Series', model: '2021', daily_price: 100, image: 'bmw.jpg', description: 'A BMW German car, I think!') }

  let!(:reservation) do 
    Reservation.create(
      user: user, 
      car: car, 
      pickup_date: Date.current + 10.days, 
      dropoff_date: Date.current + 12.days
    )
  end

  describe '#perform_async' do
    it 'queues the job with the reservation ID' do
      expect {
        ReservationConfirmationJob.perform_async(reservation.id)
      }.to change(ReservationConfirmationJob.jobs, :size).by(1)
    end
    
    it 'is enqueued with the correct reservation_id' do
      ReservationConfirmationJob.perform_async(reservation.id)
      expect(ReservationConfirmationJob.jobs.last['args']).to include(reservation.id)
    end
  end

 describe '#perform' do
    it 'finds the reservation and calls the Mailer' do
      # Pre-condition check: Ensure ID exists
      expect(reservation.id).not_to be_nil

      mailer_double = double('Mail', deliver_now: true)
      
      # Set expectation on the CLASS
      expect(ReservationMailer).to receive(:confirmation_email)
        .with(instance_of(Reservation))
        .and_return(mailer_double)

      # Call the method
      ReservationConfirmationJob.new.perform(reservation.id)
    end
  end
end