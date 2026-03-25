require 'swagger_helper'

RSpec.describe 'api/v1/register', type: :request do
  path '/api/v1/register' do
    post 'Register User' do
      tags 'Sign Up'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[name email password password_confirmation]
      }

      response '200', 'User registered successfully' do
        let(:user) do
          { user: { name: 'Obi Wan', email: 'obiwan@jedi.com', password: 'password',
                    password_confirmation: 'password' } }
        end
        run_test!
      end

      response '422', 'Invalid request' do
        let(:user) { 'invalid' }
        run_test!
      end
    end
  end
end
