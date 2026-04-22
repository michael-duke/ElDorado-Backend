class Api::V1::CarsController < ApplicationController
  include ResourceFindable

  before_action :set_resource, only: %i[show]

  def index
    @cars = Car.available.order(:id)
    serialized_data = @cars.map { |car| CarSerializer.new(car).serializable_hash }

    json_response({
                    status: 200,
                    message: 'Available cars retrieved successfully.',
                    data: serialized_data
                  }, :ok)
  end

  def show
    json_response({
                    status: 200,
                    message: 'Single car retrieved successfully.',
                    data: CarSerializer.new(@car).serializable_hash
                  }, :ok)
  end
end
