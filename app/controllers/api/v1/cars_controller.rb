class Api::V1::CarsController < ApplicationController
  before_action :set_car, only: %i[show update availability]
  before_action :authenticate_user!, only: %i[create update availability all_cars]
  before_action :authorize_admin!, only: %i[create update availability all_cars]

  def index
    @cars = Car.available
    render json: @cars, status: :ok
  end

  def all_cars
    @all_cars = Car.all
    render json: @all_cars, status: :ok
  end

  def show
    render json: @car, status: :ok
  end

  def create
    car = Car.new(car_params)
    if car.save!
      render json: {
        status: 201,
        message: 'Car has been successfully created',
        data: CarSerializer.new(car)
      }, status: :created
    else
      render json: { error: 'ERROR: Unable to create the car' }, status: :unprocessable_entity
    end
  end

  def update
    @car = Car.find(params[:id])
    if @car.update!(car_params)
      render json: {
        status: 200,
        message: 'Car has been successfully updated.',
        data: CarSerializer.new(@car)
      }, status: :ok
    else
      render json: { error: 'ERROR: Unable to create the car' }, status: :unprocessable_entity
    end
  end

  def availability
    if @car.update(available: !@car.available) # Toggles the current state
      json_response({ 
        message: "Car is now #{@car.available ? 'available' : 'unavailable'}", 
        data: CarSerializer.new(@car) 
      }, :ok)
    else
      json_response({ error: @car.errors.full_messages }, :unprocessable_entity)
    end
  end
  

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:name, :model, :image, :daily_price, :description, :available)
  end

  def authorize_admin!
    unless current_user.admin?
      json_response({ errors: 'You are not authorized for this action.' }, :unauthorized)
    end
  end

  def car_availability_params
    params.require(:car)
      .permit(:available)
  end
end
