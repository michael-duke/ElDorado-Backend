require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  # --- REGISTRATION ---
  path '/api/v1/auth/register' do
    post 'User Registration' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body,
                schema: { '$ref' => '#/components/schemas/user_registration_request' }

      response '201', 'User registered successfully' do
        header 'Authorization', type: :string, description: 'JWT Bearer Token'
        schema '$ref' => '#/components/schemas/user_response'
        let(:user) do
          { user: { name: 'Cassius Andor', email: 'cassius@rebel.org',
                    password: 'password', password_confirmation: 'password' } }
        end

        after do |_example|
          expect(response.headers['Authorization']).to be_present
          expect(response.headers['Authorization']).to include('Bearer')
        end

        run_test!
      end

      response '422', 'Validation Error' do
        schema '$ref' => '#/components/schemas/error'
        let(:user) do
          { user: { name: '', email: 'bad_email',
                    password: '1', password_confirmation: '2' } }
        end
        run_test!
      end
    end
  end

  # --- LOGIN ---
  path '/api/v1/auth/login' do
    post 'Sign in User' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: { '$ref' => '#/components/schemas/user_login_request' }
      response '200', 'User logged in successfully' do
        header 'Authorization', type: :string, description: 'JWT Bearer Token'
        schema '$ref' => '#/components/schemas/user_response'
        let!(:existing_user) do
          User.create!(name: 'Cassius Andor', email: 'cassius@rebel.org',
                       password: 'password')
        end
        let(:credentials) { { user: { email: 'cassius@rebel.org', password: 'password' } } }

        after do |_example|
          expect(response.headers['Authorization']).to be_present
          expect(response.headers['Authorization']).to include('Bearer')
        end
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/error'
        let(:credentials) { { user: { email: 'traitor@empire.gov', password: 'wrong' } } }
        run_test!
      end
    end
  end

  # --- LOGOUT ---
  path '/api/v1/auth/logout' do
    delete 'Sign out User' do
      tags 'Authentication'
      security [{ bearerAuth: [] }]
      let(:Authorization) { nil }

      response '200', 'User logged out successfully' do
        schema type: :object,
               properties: {
                 status: { type: :integer, example: 200 },
                 message: { type: :string }
               }
        let(:user) do
          User.create!(name: 'Cassius Andor', email: 'cassius@rebel.org',
                       password: 'password')
        end
        let(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }

        # --- THE IDEMPOTENCY CHECK ---
        after do |_example|
          expect(response).to have_http_status(:ok)
          jwt_token = send(:Authorization)
          delete '/api/v1/auth/logout', headers: { 'Authorization' => jwt_token }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        end
        run_test!
      end
    end
  end
end
