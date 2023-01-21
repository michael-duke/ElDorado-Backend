require 'swagger_helper'

RSpec.describe 'api/v1/owner_cars', type: :request do
  path '/api/v1/all_cars/' do
    get 'List all Cars that are created by Admin' do
      tags 'All Cars in the System, Admin Only'
      produces 'application/json'
      response '200', 'List of all cars found' do
        before do
          @user = User.create(name: 'Master Yoda', email: 'yoda@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          @cars = Car.create([
                               { name: 'Alfa Romeo',
                                 image: 'https://www.alfaromeousa.com/alfa-romeo-stelvio-1920x1080.jpg',
                                 model: '2021', daily_price: 1000,
                                 description: 'The Alfa Romeo Stelvio is a compact luxury crossover SUV' },
                               { name: 'McLaren',
                                 image: 'https://www.mclaren.com/content/mclaren-720s-1920x1080.jpg',
                                 model: '2021', daily_price: 1000,
                                 description: 'The McLaren 720S is a British sports car produced by
                                 McLaren Automotive.' },
                               { name: 'Mercedes-Benz',
                                 image: 'https://www.mbusa.com/content/mercedes-benz-gls-1920x1080.jpg',
                                 model: '2021', daily_price: 1000,
                                 description: 'The Mercedes-Benz GLS-Class is a full-size luxury SUV
                                 produced by the German automaker.' }
                             ])
          sign_in @user
        end
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   image: { type: :string },
                   model: { type: :string },
                   daily_price: { type: :decimal },
                   description: { type: :text },
                   available: { type: :boolean }
                 },
                 required: %w[id name image model daily_price description available]
               }
        run_test!
      end
    end
  end

  path '/api/v1/cars' do
    post 'Create a New Car' do
      tags 'Create a New Car, Admin Only'
      consumes 'application/json'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          image: { type: :string },
          model: { type: :string },
          daily_price: { type: :decimal },
          description: { type: :text },
          available: { type: :boolean }
        },
        required: %w[id name image model daily_price description available]
      }
      response '201', 'Car created successfully' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          sign_in @user
        end
        let(:car) do
          { name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Prius', daily_price: 100, description: 'A nice car', available: true }
        end
        run_test!
      end
      response '401', 'Unauthorized, only Admin can create a new car' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 0)
          sign_in @user
        end
        let(:user_id) { @user.id }
        let(:car) do
          { name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Prius', daily_price: 100, description: 'A nice car', available: true }
        end
        run_test!
      end
      response '422', 'Car couldn\'t be created invalid request or validation failed' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          sign_in @user
        end
        let(:user_id) { @user.id }
        let(:car) do
          { name: nil, image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Prius', daily_price: 100, description: 'A nice car', available: false }
        end
        run_test!
      end
    end
  end

  path '/api/v1/cars/{id}' do
    put 'Update a Car' do
      tags 'Update a Car, Admin Only'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Car ID'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          image: { type: :string },
          model: { type: :string },
          daily_price: { type: :decimal },
          description: { type: :text },
          available: { type: :boolean }
        },
        required: %w[id name image model daily_price description available]
      }
      response '200', 'Car updated successfully' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@gmail.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          @car = Car.create(name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Prius', daily_price: 100, description: 'A nice car', available: true)
          sign_in @user
        end
        let(:id) { @car.id }
        let(:car) do
          { name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Camry', daily_price: 100, description: 'A nice updated car', available: false }
        end
        run_test!
      end
      response '401', 'You are not authorized to update this car' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@gmail.com', password: 'password',
                              password_confirmation: 'password', role: 0)
          @car = Car.create(name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Prius', daily_price: 100, description: 'A nice car', available: true)
        end
        let(:id) { @car.id }
        let(:car) do
          { name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Prius', daily_price: 100, description: 'A nice car', available: true }
        end
        run_test!
      end
      response '404', 'Car not found' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          sign_in @user
        end
        let(:id) { 'invalid' }
        let(:car) do
          { name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Prius', daily_price: 100, description: 'A nice car', available: true }
        end
        run_test!
      end
      response '422', 'Car couldn\'t be updated invalid request or validation failed' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          @car = Car.create(name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Prius', daily_price: 100, description: 'A nice car', available: true)
          sign_in @user
        end
        let(:id) { @car.id }
        let(:car) do
          { name: nil, image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
            model: 'Prius', daily_price: 100, description: 'A nice car', available: false }
        end
        run_test!
      end
    end
  end
  path '/api/v1/cars/{id}/availability' do
    patch 'Mark Car as Removed' do
      tags 'Mark Car as Removed/Available, Admin Only'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Car ID'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          available: { type: :boolean }
        },
        required: %w[available]
      }
      response '200', 'Car updated successfully' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@gmail.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          @car = Car.create(name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Prius', daily_price: 100, description: 'A nice car', available: true)
          sign_in @user
        end
        let(:id) { @car.id }
        let(:car) do
          { available: false }
        end
        run_test!
      end
      response '401', 'You are not authorized to update the availability of this car' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@gmail.com', password: 'password',
                              password_confirmation: 'password', role: 0)
          @car = Car.create(name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Prius', daily_price: 100, description: 'A nice car', available: true)
        end
        let(:id) { @car.id }
        let(:car) do
          { available: true }
        end
        run_test!
      end
      response '404', 'Car not found' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          sign_in @user
        end
        let(:user_id) { @user.id }
        let(:id) { 'invalid' }
        let(:car) do
          { available: true }
        end
        run_test!
      end
      response '422', 'Car availability couldn\'t be updated invalid request or validation failed' do
        before do
          @user = User.create(name: 'Milen', email: 'milen@jedi.com', password: 'password',
                              password_confirmation: 'password', role: 1)
          @car = Car.create(name: 'Toyota', image: 'https://www.toyota.com/imgix/responsive/images/toyota.png',
                            model: 'Prius', daily_price: 100, description: 'A nice car', available: true)
          sign_in @user
        end
        let(:id) { @car.id }
        let(:car) do
          { available: '' }
        end
        run_test!
      end
    end
  end
end
