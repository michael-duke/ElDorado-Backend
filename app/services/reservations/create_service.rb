module Reservations
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      reservation = @user.reservations.build(@params)
      car = reservation.car

      Reservation.transaction do
        if reservation.save
          car.reserve!(@user)
          ReservationConfirmationJob.perform_async(reservation.id) 
          
          { success: true, reservation: reservation }
        else
          { success: false, errors: reservation.errors.full_messages }
        end
      end

    rescue AASM::InvalidTransition
      # This catches cases where the car is in 'maintenance' or 'retired'
      { success: false, errors: ["The car is currently #{car.status} and cannot be reserved."] }
    rescue => e
      { success: false, errors: [e.message] }
    end
  end
end