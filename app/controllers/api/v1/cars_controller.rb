class Api::V1::CarsController < ApplicationController
  before_action :set_car, only: %i[show update availability]
  before_action :authenticate_user!, only: %i[create update availability owner_cars]

  def index
    @cars = Car.where(available: true)
    render json: @cars, status: :ok
  end

  def owner_cars
    @owner_cars = Car.where(user: current_user)
    render json: @owner_cars, status: :ok
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
 private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car)
      .permit(:name, :model, :image, :daily_price, :description, :available)
      .with_defaults(user_id: current_user.id)
  end

end
