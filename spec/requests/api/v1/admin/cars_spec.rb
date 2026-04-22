require 'swagger_helper'

RSpec.describe 'Api::V1::Admin::Cars' do
  # rubocop:disable RSpec/VariableName
  let(:Authorization) { 'Bearer dummy token' }
  # rubocop:enable RSpec/VariableName

  let(:admin) { User.create!(name: 'Master Admin', email: 'admin@test.com', password: 'password', role: 1) }
  let(:regular_user) { User.create!(name: 'User', email: 'user@test.com', password: 'password', role: 0) }
  let(:current_user) { admin }
  let(:tesla) do
    Car.create!(
      name: 'Tesla', image: 'tesla.png', model: 'Model S',
      daily_price: 150, description: 'Electric', status: 'available'
    )
  end

  before do
    sign_in current_user
    tesla
  end

  path '/api/v1/admin/cars' do
    get 'List all Cars (Admin Only)' do
      tags 'Admin/Cars'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response '200', 'All cars retrieved' do
        schema '$ref' => '#/components/schemas/car_collection_response'

        run_test!
      end

      response '403', 'Forbidden - Not an Admin' do
        let(:current_user) { regular_user }
        run_test!
      end
    end

    post 'Create a New Car' do
      tags 'Admin/Cars'
      consumes 'application/json'
      security [{ bearerAuth: [] }]
      parameter name: :car, in: :body, schema: { '$ref' => '#/components/schemas/car_request' }

      response '201', 'Car created successfully' do
        schema '$ref' => '#/components/schemas/car_single_response'
        # FIXED: Wrapped the hash in an extra set of braces
        let(:car) do
          { car: { name: 'Toyota', image: 'img.png', model: '2024', daily_price: 100.99, description: 'New car',
                   status: 'available' } }
        end

        run_test!
      end

      response '422', 'Validation failed' do
        let(:car) { { car: { name: nil } } }
        run_test!
      end
    end
  end

  path '/api/v1/admin/cars/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Car ID'

    patch 'Update a Car' do
      tags 'Admin/Cars'
      consumes 'application/json'
      security [{ bearerAuth: [] }]
      parameter name: :car, in: :body, schema: { '$ref' => '#/components/schemas/car' }

      response '200', 'Car updated successfully' do
        schema '$ref' => '#/components/schemas/car_single_response'
        let(:id) do
          Car.create!(
            name: 'Old Mustang', image: 'mustang.png', model: '2020',
            daily_price: 50, description: 'Old American muscle', status: 'reserved'
          ).id
        end
        let(:car) { { car: { name: 'Mustang Cobra', status: 'available' } } }

        run_test!
      end
    end
  end

  path '/api/v1/admin/cars/{id}/availability' do
    parameter name: :id, in: :path, type: :integer, description: 'Car ID'

    patch 'Toggle Car Availability' do
      tags 'Admin/Cars'
      security [{ bearerAuth: [] }]

      response '200', 'Status toggled successfully' do
        schema '$ref' => '#/components/schemas/car_single_response'
        let(:id) do
          Car.create!(
            name: 'Toggle', image: 'i.png', model: '2020',
            daily_price: 50, description: 'A toggle desc', status: 'available'
          ).id
        end
        run_test!
      end

      response '409', 'Conflict - Car is currently reserved' do
        schema '$ref' => '#/components/schemas/error'
        let(:id) do
          Car.create!(
            name: 'Tesla', status: 'reserved', model: 'Model Y',
            daily_price: 200.44, image: 'i.png', description: 'Tesla Model Y desc'
          ).id
        end

        run_test!
      end
    end
  end
end
