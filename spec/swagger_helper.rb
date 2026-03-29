require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'El Dorado API V1',
        version: 'v1',
        description: 'API for El Dorado Car Reservations - Built with Rails & JWT'
      },
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Local Development Server'
        },
        {
          url: 'https://{defaultHost}',
          description: 'Production Server',
          variables: {
            defaultHost: {
              default: 'eldorado.onrender.com'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT,
            description: 'Enter your JWT token in the format: <token>'
          }
        },
        schemas: {
          reservation_request: {
            type: :object,
            properties: {
              reservation: { 
                type: :object,
                properties: {
                  car_id: { type: :integer, example: 1 },
                  pickup_date: { type: :string, format: :date, example: '2026-04-10' },
                  dropoff_date: { type: :string, format: :date, example: '2026-04-15' }
                },
                required: %w[car_id pickup_date dropoff_date]
              }
            },
            required: ['reservation']
          },
          reservation_response: {
            type: :object,
            properties: {
              id: { type: :integer },
              pickup_date: { type: :string, format: :date },
              dropoff_date: { type: :string, format: :date },
              car: { '$ref' => '#/components/schemas/car' }
            },
            required: %w[id pickup_date dropoff_date car]
          },
          car: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              image: { type: :string },
              model: { type: :string },
              daily_price: { type: :string, example '100.0' },
              description: { type: :string },
              status: {type: :string}
            },
            required: %w[id name image model daily_price description]
          },
          user: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              email: { type: :string }
            }
          },
          error: {
            type: :object,
            properties: {
              status: { type: :integer },
              error: { type: :array, items: { type: :string } }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
