module Reservations
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      # 1. Logic Check: Is the car available for these dates?
      if car_already_booked?
        return { success: false, errors: ["This car is already reserved for the selected dates."] }
      end

      # 2. Build the reservation through the user (Security: ensures user_id is correct)
      reservation = @user.reservations.build(@params)

      # 3. Save and Return result
      if reservation.save
        { success: true, reservation: reservation }
      else
        { success: false, errors: reservation.errors.full_messages }
      end
    end

    private

    def car_already_booked?
      # Check if any reservation exists for this car that overlaps with the requested dates
      Reservation.where(car_id: @params[:car_id])
                 .where("(pickup_date, dropoff_date) OVERLAPS (?, ?)", 
                        @params[:pickup_date], @params[:dropoff_date])
                 .exists?
    end
  end
end