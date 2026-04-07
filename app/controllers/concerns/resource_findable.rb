module ResourceFindable
  extend ActiveSupport::Concern

  private

  def set_resource
    if params[:car_id] || params.dig(:reservation, :car_id) || params[:controller].include?('cars')
      set_car_resource
    elsif params[:id] && params[:controller].include?('reservations')
      set_reservation_resource
    end
  end

  def set_car_resource
    id = params[:car_id] || params.dig(:reservation, :car_id) || params[:id]

    if params[:controller].include?('reservations')
      @car = Car.where.not(status: :retired).find(id)
    else
      scope = current_user&.admin? ? Car : Car.available
      @car = scope.find(id)
    end

    @car.current_user = current_user if current_user
  end

  def set_reservation_resource
    scope = current_user&.admin? ? Reservation : current_user.reservations

    @reservation = scope.find(params[:id])
    @car = @reservation.car
    @car.current_user = current_user if @car && current_user
  end
end
