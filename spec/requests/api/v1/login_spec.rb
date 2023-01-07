require 'swagger_helper'

RSpec.describe 'api/v1/login', type: :request do
  path '/api/v1/login' do
    post 'Sign in User' do
      tags 'Login'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'User logged in successfully' do
        before do
          User.create(name: 'Obi Wan', email: 'obiwan@jedi.com', password: 'password',
                      password_confirmation: 'password')
        end
        let(:user) { { user: { email: 'obiwan@jedi.com', password: 'password' } } }
        run_test!
      end

      response '401', 'Logged in failure' do
        let(:user) { 'invalid' }
        run_test!
      end
    end
  end
end
