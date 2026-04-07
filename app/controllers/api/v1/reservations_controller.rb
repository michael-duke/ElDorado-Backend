class Api::V1::ReservationsController < ApplicationController
  include ResourceFindable

  wrap_parameters :reservation, include: %i[car_id pickup_date dropoff_date]

  before_action :authenticate_user!
  before_action :set_resource, only: %i[show destroy create]

  def index
    # Optimized with .includes to prevent N+1 queries
    @reservations = current_user.reservations.includes([:car]).order(id: :desc)

    serialized_data = @reservations.map { |res| ReservationSerializer.new(res).serializable_hash }
    json_response({
                    status: 200,
                    message: 'Reservations retrieved successfully.',
                    data: serialized_data
                  }, :ok)
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
                      code: result[:code],
                      message: result[:message]
                    }, result[:code])
    end
  end

  def destroy
    unless current_user.admin? || @reservation.user_id == current_user.id
      return json_response({
                             code: 403,
                             message: 'Acess Denied: You are not authorized to cancel this reservation.'
                           }, :forbidden)
    end

    Reservation.transaction do
      # Make the car available
      @reservation.car.return!
      @reservation.destroy!
    end

    json_response({
                    status: 200,
                    message: 'Reservation cancelled successfully',
                    data: ReservationSerializer.new(@reservation)
                  }, :ok)
  rescue ActiveRecord::RecordNotFound
    json_response({ code: 404, message: 'Reservation not found' }, :not_found)
  rescue StandardError => e
    json_response({ code: 500,
                    message: "An error occurred: #{e.message}" }, :internal_server_error)
  end

  private

  def reservation_params
    params.require(:reservation).permit(:pickup_date, :dropoff_date, :car_id)
  end
end
