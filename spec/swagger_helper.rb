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
          reservation_single_response: {
            type: :object,
            properties: {
              status: { type: :integer, example: 200 },
              message: { type: :string, example: 'Success' },
              data: { '$ref' => '#/components/schemas/reservation' }
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
                items: { '$ref' => '#/components/schemas/reservation' } 
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
            required: %w[id name image model daily_price description status]
          },
          car_response: {
            type: :object,
            properties: {
              status: { type: :integer },
              message: { type: :string },
              data: { '$ref' => '#/components/schemas/car' }
            }
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
            }
          },
          car_status_history_response:{
            type: :object,
            properties: {
              id: { type: :integer },
              from: { type: :string },
              to: { type: :string },
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
              car_details:{
                type: :object,
                properties: {
                  id: {type: :integer},
                  name: {type: :string},
                  model: {type: :string}
                }
              }
            }
          },
          car_status_history_collection_response:{ 
            type: :object,
            properties: {
              status: { type: :integer, example: 200 },
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/car_status_history_response' }
              }
            }
          },
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
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
                  role: { type: :string, example: 'admin' } # Good to include role for clarity
                },
                required: %w[id name email]
              }
            }
          },
          error: {
            type: :object,
              properties: {
                code: { type: :integer, example: 401 },
                message: { type: :string }
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
