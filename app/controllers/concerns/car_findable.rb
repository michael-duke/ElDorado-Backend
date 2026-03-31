module CarFindable
  extend ActiveSupport::Concern

  private

  def set_car
    id = params[:car_id] || params[:id]
    @car = Car.find(id)
  end
end