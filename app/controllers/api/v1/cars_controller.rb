class Api::V1::CarsController < ApplicationController
  before_action :set_car, only: %i[show update availability]
  before_action :authenticate_user!, only: %i[create update availability all_cars]

  def index
    @cars = Car.where(available: true)
    render json: @cars, status: :ok
  end

  def all_cars
    if current_user.admin?
      @all_cars = Car.all
      render json: @all_cars, status: :ok
    else
      render json: { errors: 'You are not authorized to view all cars.' }, status: :unauthorized
    end
  end

  def show
    render json: @car, status: :ok
  end

  def create
    if current_user.admin?
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
    else
      render json: { errors: 'You are not authorized to create a car.' }, status: :unauthorized
    end
  end

  def update
    if current_user.admin?
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
    else
      render json: { errors: 'You are not authorized to update this car.' }, status: :unauthorized
    end
  end

  def availability
    if current_user.admin?
      if @car.update!(car_availability_params)
        car_available? ? render_available : render_unavailable
      else
        render json: { error: 'ERROR: Unable to update the car' }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'You are not authorized to update this car.' }, status: :unauthorized
    end
  end

  def render_available
    render json: {
      status: 200,
      message: 'Car has been successfully marked as available.',
      data: CarSerializer.new(@car)
    }, status: :ok
  end

  def render_unavailable
    render json: {
      status: 200,
      message: 'Car has been successfully marked as unavailable.',
      data: CarSerializer.new(@car)
    }, status: :ok
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car)
      .permit(:name, :model, :image, :daily_price, :description, :available)
  end

  def car_available?
    @car.available
  end

  def car_availability_params
    params.require(:car)
      .permit(:available)
  end
end
