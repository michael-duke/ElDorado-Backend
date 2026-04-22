require 'swagger_helper'

RSpec.describe 'Api::V1::Admin::CarStatusHistories' do
  # rubocop:disable RSpec/VariableName
  let(:Authorization) { 'Bearer dummy token' }
  # rubocop:enable RSpec/VariableName

  # Define shared resources at the top level
  let(:admin) { User.create!(role: 1, email: 'admin@test.com', password: 'password', name: 'Admin Michael') }
  let(:user) { User.create!(role: 0, email: 'user@test.com', password: 'password', name: 'Customer X') }
  let(:car) do
    Car.create!(
      name: 'Camry', status: 'available', model: '2024',
      daily_price: 100, image: 'i.png', description: 'Toyota Camry desc'
    )
  end

  let(:car_id) { car.id }
  let(:current_user) { admin }

  before do
    sign_in current_user
    CarStatusHistory.create!(
      car: car, user: admin,
      from_status: 'available', to_status: 'maintenance'
    )
  end

  path '/api/v1/admin/cars/{car_id}/status_histories' do
    parameter name: :car_id, in: :path, type: :integer, description: 'ID of the car to view history for'

    get 'Retrieve Car Maintenance History (Admin Only)' do
      tags 'Admin/Audit Logs'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response '200', 'Logs retrieved successfully' do
        schema '$ref' => '#/components/schemas/car_status_history_collection_response'

        run_test!
      end

      response '403', 'Forbidden - User is not an admin' do
        let(:current_user) { user }

        run_test!
      end

      response '404', 'Car not found' do
        let(:car_id) { 99_999 }

        run_test!
      end
    end
  end
end
