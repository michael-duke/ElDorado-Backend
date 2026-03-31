require 'swagger_helper'

RSpec.describe 'api/v1/cars', type: :request do
  path '/api/v1/cars' do
    get 'List all Cars' do
      tags 'Cars'
      produces 'application/json'

      response '200', 'List of available cars found' do
        schema '$ref' => '#/components/schemas/car_collection_response'

        before do
          Car.create!(
            name: 'Alfa Romeo',
            image: 'https://example.com/alfa.jpg',
            model: '2021', 
            daily_price: 1000, 
            description: 'Luxury crossover SUV'
          )
        end
        run_test!
      end
    end
  end

  path '/api/v1/cars/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Car ID'

    get 'Get Specific Car' do
      tags 'Cars'
      produces 'application/json'

      response '200', 'Single Car found' do
        schema '$ref' => '#/components/schemas/car_response'

        let(:car) { Car.create!(name: 'McLaren', image: 'https://rebels/McLaren.jpg', model: '2021', daily_price: 1000, description: 'Sports car') }
        let(:id) { car.id }
        
        run_test!
      end

      response '404', 'Car not found' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end