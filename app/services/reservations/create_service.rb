module Reservations
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      if car_already_booked?
        return { success: false, errors: ["This car is already reserved for these dates."] }
      end

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

    private

    def car_already_booked?
      # Date-specific conflicts
      Reservation.where(car_id: @params[:car_id])
                 .where("pickup_date < ? AND dropoff_date > ?", 
                        @params[:dropoff_date], @params[:pickup_date])
                 .exists?
    end
  end
end