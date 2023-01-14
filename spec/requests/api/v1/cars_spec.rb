require 'swagger_helper'

RSpec.describe 'api/v1/cars', type: :request do
  path '/api/v1/cars/' do
    get 'List all Cars' do
      tags 'List All Cars'
      produces 'application/json'
      response '200', 'List of cars found' do
        before do
          user = User.create(name: 'Master Yoda', email: 'yoda@jedi.com', password: 'password',
                             password_confirmation: 'password')
          @cars = Car.create([
                               { user:, name: 'Alfa Romeo',
                                 image: 'https://www.alfaromeousa.com/alfa-romeo-stelvio-1920x1080.jpg',
                                 model: '2021', daily_price: 1000, available: true,
                                 description: 'The Alfa Romeo Stelvio is a compact luxury crossover SUV' },
                               { user:, name: 'McLaren',
                                 image: 'https://www.mclaren.com/content/mclaren-720s-1920x1080.jpg',
                                 model: '2021', daily_price: 1000, available: true,
                                 description: 'The McLaren 720S is a British sports car produced by
                                 McLaren Automotive.' },
                               { user:, name: 'Mercedes-Benz',
                                 image: 'https://www.mbusa.com/content/mercedes-benz-gls-1920x1080.jpg',
                                 model: '2021', daily_price: 1000, available: true,
                                 description: 'The Mercedes-Benz GLS-Class is a full-size luxury SUV
                                 produced by the German automaker.' }
                             ])
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

  path '/api/v1/cars/{id}' do
    get 'List Specific Car' do
      tags 'Get Single Car'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Car ID'

      response '200', 'Single Car was found' do
        before do
          user = User.create(name: 'Master Yoda', email: 'yoda@jedi.com', password: 'password',
                             password_confirmation: 'password')
          @cars = Car.create([
                               { user:, name: 'Alfa Romeo',
                                 image: 'https://www.alfaromeousa.com/alfa-romeo-stelvio-1920x1080.jpg',
                                 model: '2021', daily_price: 1000, available: true,
                                 description: 'The Alfa Romeo Stelvio is a compact luxury crossover SUV' },
                               { user:, name: 'McLaren',
                                 image: 'https://www.mclaren.com/content/mclaren-720s-1920x1080.jpg',
                                 model: '2021', daily_price: 1000, available: true,
                                 description: 'The McLaren 720S is a British sports car produced by
                                 McLaren Automotive.' },
                               { user:, name: 'Mercedes-Benz',
                                 image: 'https://www.mbusa.com/content/mercedes-benz-gls-1920x1080.jpg',
                                 model: '2021',
                                 daily_price: 1000, available: true,
                                 description: 'The Mercedes-Benz GLS-Class is a full-size luxury SUV
              produced by the German automaker.' }
                             ])
        end

        schema type: :object,
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
        let(:id) { @cars.first.id }
        run_test!
      end

      response '404', 'Invalid Record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
