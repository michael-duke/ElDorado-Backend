class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.reservations.includes([:car]).order(id: :desc), status: :ok
  end

  def create
    reservation = Reservation.new(reservation_params)
    if reservation.save!
      render json: {
        status: 201,
        message: 'Car has been successfully reserved.',
        data: ReservationSerializer.new(reservation)
      }, status: :created
    else
      render json: { error: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    reservation = Reservation.find(params[:id])

    if reservation.destroy
      render json: {
        status: 200,
        message: 'Reservation successfully canceled',
        data: ReservationSerializer.new(reservation)
      }, status: :ok
    else
      render json: { error: 'ERROR: Unable to cancel the reservation' }, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:pickup_date, :dropoff_date, :car_id)
  end
end

class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Optimized with .includes to prevent N+1 queries
    @reservations = current_user.reservations.includes([:car]).order(id: :desc)
    json_response(@reservations)
  end

  def create
    # Hand off logic to the Service Object
    result = Reservations::CreateService.new(current_user, reservation_params).call

    if result[:success]
      json_response({
        status: 201,
        message: 'Car has been successfully reserved.',
        data: ReservationSerializer.new(result[:reservation])
      }, :created)
    else
      json_response({ 
        status: 422,
        error: result[:errors] 
      }, :unprocessable_entity)
    end
  end

  def destroy
    reservation = current_user.reservations.find(params[:id])

    if reservation.destroy
      json_response({
        status: 200,
        message: 'Reservation successfully canceled',
        data: ReservationSerializer.new(reservation)
      })
    else
      json_response({ error: 'ERROR: Unable to cancel the reservation' }, :unprocessable_entity)
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:pickup_date, :dropoff_date, :car_id)
  end
end