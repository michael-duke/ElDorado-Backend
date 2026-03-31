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
          { 
            success: false, 
            code: 422, 
            message: reservation.errors.full_messages.to_sentence 
          }
        end
      end

    rescue AASM::InvalidTransition
      { 
        success: false, 
        code: 422, 
        message: "This car is currently #{car&.status} and cannot be reserved." 
      }
    rescue => e
      { 
        success: false, 
        code: 500, 
        message: "An unexpected error occurred: #{e.message}" 
      }
    end
  end
end