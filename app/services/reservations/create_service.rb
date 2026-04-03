module Reservations
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      car_id = @params[:car_id] || @params.dig(:reservation, :car_id)
      @car = Car.find(car_id)

      # Attach the current_user to the car.
      @car.current_user = @user 

      reservation = @user.reservations.build(@params.merge(car: @car))

      Reservation.transaction do
        if reservation.save
          reservation.car.reserve!

          ReservationConfirmationJob.perform_later(reservation.id) 
          
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
        message: "This car is currently #{@car&.status} and cannot be reserved." 
      }
    rescue => e
      Rails.logger.error "Reservation Service Error: #{e.message}"
      { success: false, code: 500, message: "Unexpected error: #{e.message}" }
    end
  end
end