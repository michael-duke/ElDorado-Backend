require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder

  # Old config.swagger_root = Rails.root.join('swagger').to_s
  config.openapi_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'El Dorado API V1',
        version: 'v1',
        description: 'API for El Dorado Car Reservations - Built with Rails & JWT'
      },
     servers: [
        {
          url: 'http://localhost:3001',
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
            description: 'Enter your JWT token (e.g., eyJhbGciOiJIUzI1...)'
          }
        },
        schemas: {
          reservation: {
            type: :object,
            properties: {
              id: { type: :integer },
              pickup_date: { type: :string, format: 'date-time' },
              dropoff_date: { type: :string, format: 'date-time' },
              car: { '$ref' => '#/components/schemas/car' }
            },
            required: %w[id pickup_date dropoff_date car]
          },
          reservation_request: {
            type: :object,
            properties: {
              car_id: { type: :integer, example: 1 },
              pickup_date: { type: :string, format: 'date-time', example: '2026-04-01T10:00:00Z' },
              dropoff_date: { type: :string, format: 'date-time', example: '2026-04-05T10:00:00Z' }
            },
            required: %w[car_id pickup_date dropoff_date]
          },
          reservation_single_response: {
            type: :object,
            properties: {
              status: { type: :integer, example: 200 },
              message: { type: :string, example: 'Success' },
              data: { 
                type: :object,
                  properties: {
                    id: { type: :integer },
                    pickup_date: { type: :string, format: 'date-time' },
                    dropoff_date: { type: :string, format: 'date-time' },
                    car: { '$ref' => '#/components/schemas/car' }
                  },
                  required: %w[id pickup_date dropoff_date car]
               }
            },
            required: %w[status message data]
          },
          reservation_collection_response: {
            type: :object,
            properties: {
              status: { type: :integer, example: 200 },
              message: { type: :string, example: 'Reservations retrieved' },
              data: { 
                type: :array, 
                items: { 
                  '$ref' => '#/components/schemas/reservation' } 
              }
            },
            required: %w[status message data]
          },
          car: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              image: { type: :string },
              model: { type: :string, example: '2022 SV' },
              daily_price: { type: :string, example: '1000.0' },
              description: { type: :string },
              status: { type: :string, example: 'available' }
            },
            required: %w[name image model daily_price description status]
          },
          car_request: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Tesla Model 3' },
              image: { type: :string, example: 'https://example.com/car.jpg' },
              model: { type: :string, example: '2024 Performance' },
              daily_price: { type: :number, example: 150.00 },
              description: { type: :string, example: 'All-electric sedan with Autopilot.' }
            },
            required: %w[name image model daily_price]
          },
          car_single_response: {
            type: :object,
            properties: {
              status: { type: :integer },
              message: { type: :string },
              data: { '$ref' => '#/components/schemas/car' }
            },
            required: %w[status message data]
          },
          car_collection_response: {
            type: :object,
            properties: {
              status: { type: :integer },
              message: { type: :string },
              data: { 
                type: :array, 
                items: { '$ref' => '#/components/schemas/car' } 
              }
            },
            required: %w[status message data]
          },
          car_status_history_response:{
            type: :object,
            properties: {
              id: { type: :integer },
              from_status: { type: :string },
              to_status: { type: :string },
              notes: { type: :text },
              created_at: { type: :string, format: 'date-time' },
              user_details: {
                type: :object,
                properties: {
                  id: {type: :integer},
                  name: {type: :string},
                  email: {type: :string}
                }
              },
              car_details: {
                type: :object,
                properties: {
                  id: {type: :integer},
                  name: {type: :string},
                  model: {type: :string}
                }
              }
            },
            required: %w[id from_status to_status notes created_at user_details car_details]
          },
          car_status_history_collection_response:{ 
            type: :object,
            properties: {
              status: { type: :integer, example: 200 },
              message: { type: :string },
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/car_status_history_response' }
              }
            },
            required: %w[status message data]
          },
          user_login_request: {
            type: :object,
            properties: {
              email: { type: :string, example: 'cassius@rebel.org' },
              password: { type: :string, format: 'password', example: 'password123' }
            },
            required: %w[email password]
          },
          user_registration_request: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Cassius Andor' },
              email: { type: :string, example: 'cassius@rebel.org' },
              password: { type: :string, format: 'password', example: 'password123' },
              password_confirmation: { type: :string, format: 'password', example: 'password123' }
            },
            required: %w[name email password password_confirmation]
          },
          user_response: {
            type: :object,
            properties: {
              status: { type: :integer, example: 200 },
              message: { type: :string },
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  email: { type: :string },
                  role: { type: :string, example: 'admin' }
                },
                required: %w[id name email]
              }
            }
          },
          error: {
            type: :object,
            properties: {
              code: { type: :integer, example: 401 },
              message: { type: :string, example: 'Invalid credentials' }
            },
            required: %w[code message]
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  # Old: config.swagger_format = :yaml
  config.openapi_format = :yaml
end
