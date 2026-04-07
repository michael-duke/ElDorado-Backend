require 'swagger_helper'

RSpec.describe 'Api::V1::Admin::CarStatusHistories', type: :request do
  let(:Authorization) { 'Bearer dummy token' }
  path '/api/v1/admin/cars/{car_id}/status_histories' do
    parameter name: :car_id, in: :path, type: :integer, description: 'ID of the car to view history for'

    get 'Retrieve Car Maintenance History (Admin Only)' do
      tags 'Admin/Audit Logs'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response '200', 'Logs retrieved successfully' do
        schema '$ref' => '#/components/schemas/car_status_history_collection_response'

        let(:admin) do
          User.create!(role: 1, email: 'admin_audit@test.com', password: 'password', name: 'Admin Michael')
        end
        let(:car) do
          Car.create!(name: 'Camry', status: 'available', model: '2024', daily_price: '100', image: 'i.png',
                      description: 'Toyota Camry desc')
        end
        let(:car_id) { car.id }

        before do
          # Create a dummy history entry to test the data return
          CarStatusHistory.create!(car: car, user: admin, from_status: 'available', to_status: 'maintenance')
          sign_in admin
        end

        run_test!
      end

      response '403', 'Forbidden - User is not an admin' do
        let(:user) { User.create!(role: 0, email: 'customer@test.com', password: 'password', name: ' Customer X') }
        let(:car_id) { 1 }

        before { sign_in user }
        run_test!
      end

      response '404', 'Car not found' do
        let(:admin) { User.create!(role: 1, email: 'admin_404@test.com', password: 'password', name: 'Admin 44') }
        let(:car_id) { 99_999 } # Non-existent ID

        before { sign_in admin }
        run_test!
      end
    end
  end
end
