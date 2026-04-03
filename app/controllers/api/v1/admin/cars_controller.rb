class Api::V1::Admin::CarsController < Api::V1::Admin::AdminController
  include ResourceFindable
  before_action :set_resource, only: %i[show update availability]

  def index
    @cars = Car.all
    render_cars('All cars retrieved successfully.')
  end

  def show
    json_response({
      status: 200,
      message: "Single car retrieved successfully.",
      data: CarSerializer.new(@car)
    }, :ok)
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      json_response({ status: 201, message: 'Car created.', data: CarSerializer.new(@car) }, :created)
    else
      json_response({ code: 422, message: @car.errors.full_messages.to_sentence }, :unprocessable_entity)
    end
  end

  def update
    if @car.update(car_params)
      json_response({ status: 200, message: 'Car updated.', data: CarSerializer.new(@car) })
    else
      json_response({ code: 422, message: @car.errors.full_messages.to_sentence }, :unprocessable_entity)
    end
  end

  def availability
    case
    when @car.available?
      @car.repair!
      msg = "Car is now in maintenance."
    when @car.maintenance?
      @car.repair_complete!
      msg = "Car is now available for rent."
    else
      return json_response({ code: 409, message: "Conflict: Car is #{@car.status}" }, :conflict)
    end

    json_response({ status: 200, message: msg, data: CarSerializer.new(@car) },:ok)
  end

  private

  def car_params
    params.require(:car).permit(:name, :model, :image, :daily_price, :description, :status)
  end

  def render_cars(message)
    serialized = @cars.map { |c| CarSerializer.new(c).serializable_hash }
    json_response({ status: 200, message: message, data: serialized },:ok)
  end
end