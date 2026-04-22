require 'swagger_helper'

RSpec.describe 'Api::V1::Reservations' do
  # rubocop:disable RSpec/VariableName
  let(:token) { 'Bearer dummy token' }
  # For Swagger UI Authorization
  let(:Authorization) { token }
  # rubocop:enable RSpec/VariableName

  let(:user) do
    User.create!(name: 'Cassian', email: 'cassian@rebel.org', password: 'password', password_confirmation: 'password')
  end
  let(:car) do
    Car.create!(name: 'Toyota', image: 't.png', model: 'Camry', daily_price: 100.00, description: 'Nice car')
  end
  let(:available_car) do
    Car.create!(name: 'Ford', image: 'f.png', model: 'Mustang', daily_price: 150.00, description: 'Fast car')
  end
  let(:current_user) { user }

  before do
    sign_in current_user
    Reservation.create!(user: current_user, car: car, pickup_date: Time.zone.today,
                        dropoff_date: Time.zone.today + 1.day)
  end

  path '/api/v1/reservations' do
    get 'Get user car reservations' do
      tags 'Reservations'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response '200', 'Reservations retrieved' do
        schema '$ref' => '#/components/schemas/reservation_collection_response'

        run_test!
      end
    end

    post 'Reserve A Car' do
      tags 'Reservations'
      consumes 'application/json'
      security [{ bearerAuth: [] }]

      parameter name: :reservation, in: :body,
                schema: { '$ref' => '#/components/schemas/reservation_request' }

      response '201', 'Reservation created successfully' do
        schema '$ref' => '#/components/schemas/reservation_single_response'

        let(:reservation) do
          {
            reservation: {
              car_id: available_car.id,
              pickup_date: Date.tomorrow,
              dropoff_date: Date.tomorrow + 3.days
            }
          }
        end
        run_test!
      end

      response '422', 'Validation failed' do
        schema '$ref' => '#/components/schemas/error'
        let(:reservation) { { reservation: { car_id: car.id, pickup_date: Date.tomorrow } } }
        run_test!
      end
    end
  end

  path '/api/v1/reservations/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Reservation ID'

    delete 'Delete a car reservation' do
      tags 'Reservations'
      security [{ bearerAuth: [] }]

      response '200', 'Reservation deleted successfully' do
        schema '$ref' => '#/components/schemas/reservation_single_response'

        let(:id) do
          res = Reservation.create!(
            user: current_user,
            car: available_car,
            pickup_date: Time.zone.today + 10.days,
            dropoff_date: Time.zone.today + 12.days
          )
          available_car.current_user = current_user
          available_car.reserve!
          res.id
        end

        run_test!
      end

      response '404', 'Reservation not found' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end
