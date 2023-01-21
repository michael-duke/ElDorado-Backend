require 'swagger_helper'

RSpec.describe 'api/v1/reservations', type: :request do
  path '/api/v1/users/{user_id}/reservations' do
    get 'Get user car reservations' do
      tags 'Car Reservations'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'Current User ID'

      response '200', 'User Car reservation found' do
        before do
          @user = User.create(name: 'Abel G', email: 'abelg@jedi.com', password: 'password',
                              password_confirmation: 'password')
          @car = Car.create(name: 'Toyota',
                            image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Camry', daily_price: 100, description: 'A nice car', available: true)
          pickup_date = Time.now
          return_date = pickup_date + 5.day
          @reservation = Booking.create(user: @user, car: @car, pickup_date:, return_date:)
          sign_in @user
        end

        let(:user_id) { @user.id }

        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   pickup_date: { type: :date },
                   return_date: { type: :date },
                   car: { type: :object,
                          properties: {
                            id: { type: :integer },
                            name: { type: :string },
                            image: { type: :string },
                            model: { type: :string },
                            daily_price: { type: :decimal },
                            description: { type: :string }
                          },
                          required: %w[id name image model daily_price description] }
                 },
                 required: %w[id pickup_date return_date car]
               }
        run_test!
      end

      response '401', 'You must Login or Register. Car Reservation not found' do
        let(:user_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/reservations' do
    post 'Reserve A Car' do
      tags 'Create Car Reservation'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'Current User ID'
      parameter name: :booking, in: :body, schema: {
        type: :object,
        properties: {
          pickup_date: { type: :date },
          return_date: { type: :date },
          car_id: { type: :integer }
        },
        required: %w[pickup_date return_date car_id]
      }

      response '201', 'Reservation created successfully' do
        before do
          @user = User.create(name: 'Abel G', email: 'abelg@jedi.com', password: 'password',
                              password_confirmation: 'password')
          @car = Car.create(name: 'Toyota',
                            image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Camry', daily_price: 100, description: 'A nice car', available: false)
          @pickup_date = Time.now + 1.day
          @return_date = @pickup_date + 7.day
          sign_in @user
        end
        let(:user_id) { @user.id }
        let(:booking) { { booking: { pickup_date: @pickup_date, return_date: @return_date, car_id: @car.id } } }
        run_test!
      end

      response '401', 'You need to Sign in before continuing' do
        let(:user_id) { 'invalid' }
        let(:booking) { { booking: { pickup_date: @pickup_date, return_date: @return_date } } }
        run_test!
      end

      response '422', 'Reservation couldn\'t be created invalid request or validation failed' do
        before do
          @user = User.create(name: 'Abel G', email: 'abelg@jedi.com', password: 'password',
                              password_confirmation: 'password')
          @car = Car.create(name: 'Toyota',
                            image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Camry', daily_price: 100, description: 'A nice car', available: true)
          @pickup_date = Time.now + 1.day
          @return_date = @pickup_date + 7.day
          sign_in @user
        end
        let(:user_id) { @user.id }
        let(:booking) { { booking: { return_date: @return_date, car_id: @car.id } } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/reservations/{id}' do
    delete 'Delete a car reservation' do
      tags 'Remove Car Reservation'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'Current User ID'
      parameter name: :id, in: :path, type: :integer, description: 'Reservation ID'

      response '200', 'Reservation deleted successfully' do
        before do
          @user = User.create(name: 'Abel G', email: 'abelg@jedi.com', password: 'password',
                              password_confirmation: 'password')
          @car = Car.create(name: 'Toyota',
                            image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Camry', daily_price: 100, description: 'A nice car', available: false)
          pickup_date = Time.now + 1.day
          return_date = pickup_date + 5.day
          @reservation = Booking.create!(user: @user, car: @car, pickup_date:, return_date:)
          sign_in @user
        end

        let(:user_id) { @user.id }
        let(:id) { @reservation.id }
        run_test!
      end

      response '401', 'You need to Sign in before continuing' do
        let(:user_id) { 'invalid' }
        let(:id) { 'invalid' }
        run_test!
      end

      response '404', 'Coudn\'t find booking with the current id' do
        before do
          @user = User.create(name: 'Abel G', email: 'abelg@jedi.com', password: 'password',
                              password_confirmation: 'password')
          @car = Car.create(name: 'Toyota',
                            image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Camry', daily_price: 100, description: 'A nice car', available: true)
          pickup_date = Time.now + 1.day
          return_date = pickup_date + 5.day
          @reservation = Booking.create!(user: @user, car: @car, pickup_date:, return_date:)
          sign_in @user
        end
        let(:user_id) { @user.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
