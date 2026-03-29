require 'swagger_helper'

RSpec.describe 'api/v1/reservations', type: :request do
  let!(:user) { User.create(name: 'Cassian Andor', email: 'cassian@rebellion.com', password: 'password', password_confirmation: 'password') }
  let!(:car) { Car.create(name: 'Toyota', image: 'toyota.png', model: 'Camry', daily_price: 100, description: 'A nice car') }
  
  # For Swagger UI Authorization
  let(:Authorization) { "Bearer dummy token" } 

  path '/api/v1/reservations' do
    get 'Get user car reservations' do
      tags 'Reservations'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Reservations retrieved' do
        schema type: :array, items: { '$ref' => '#/components/schemas/reservation_response' }
        
        before do
          sign_in user
          Reservation.create!(user: user, car: car, pickup_date: Date.today, dropoff_date: Date.today + 5.days)
        end
        run_test!
      end
    end

    post 'Reserve A Car' do
      tags 'Reservations'
      consumes 'application/json'
      security [bearerAuth: []]
      
      parameter name: :reservation, in: :body, schema: { '$ref' => '#/components/schemas/reservation_request' }

      response '201', 'Reservation created successfully' do
        schema '$ref' => '#/components/schemas/reservation_response'
        
        before { sign_in user }
        let(:reservation) { { reservation: { car_id: car.id, pickup_date: Date.tomorrow, dropoff_date: Date.tomorrow + 3.days } } }
        run_test!
      end

      response '422', 'Validation failed' do
        schema '$ref' => '#/components/schemas/error'
        
        before { sign_in user }
        let(:reservation) { { reservation: { car_id: car.id, pickup_date: Date.tomorrow } } } # Missing dropoff
        run_test!
      end
    end
  end

  path '/api/v1/reservations/{id}' do
    parameter name: :id, in: :path, type: :integer

    delete 'Delete a car reservation' do
      tags 'Reservations'
      security [bearerAuth: []]

      response '204', 'Reservation deleted successfully' do
        before do
          sign_in user
          @res = Reservation.create!(user: user, car: car, pickup_date: Date.today + 10.days, dropoff_date: Date.today + 12.days)
        end
        let(:id) { @res.id }
        run_test!
      end

      response '404', 'Reservation not found' do
        before { sign_in user }
        let(:id) { 999 }
        run_test!
      end
    end
  end
end