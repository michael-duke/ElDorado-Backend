require 'swagger_helper'

RSpec.describe 'Authentication API' do
  # --- REGISTRATION ---
  describe 'Api::V1::Auth::Registrations' do
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

          run_test! do |response|
            expect(response.headers['Authorization']).to be_present
            expect(response.headers['Authorization']).to include('Bearer')
          end
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
  end

  describe 'Api::V1::Auth::Sessions' do
    # --- LOGIN ---
    path '/api/v1/auth/login' do
      post 'Sign in User' do
        tags 'Authentication'
        consumes 'application/json'
        parameter name: :credentials, in: :body, schema: { '$ref' => '#/components/schemas/user_login_request' }
        response '200', 'User logged in successfully' do
          header 'Authorization', type: :string, description: 'JWT Bearer Token'
          schema '$ref' => '#/components/schemas/user_response'
          let(:existing_user) do
            User.create!(name: 'Cassius Andor', email: 'cassius@rebel.org', password: 'password')
          end
          let(:credentials) { { user: { email: existing_user.email, password: 'password' } } }

          run_test! do |response|
            expect(response.headers['Authorization']).to be_present
            expect(response.headers['Authorization']).to include('Bearer')
          end
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

        # rubocop:disable RSpec/VariableName
        let(:Authorization) { nil }
        # rubocop:enable RSpec/VariableName

        response '200', 'User logged out successfully' do
          schema type: :object,
                 properties: {
                   status: { type: :integer, example: 200 },
                   message: { type: :string }
                 }
          let(:token_header) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }
          # rubocop:disable RSpec/VariableName
          let(:Authorization) { token_header }
          # rubocop:enable RSpec/VariableName

          let(:user) { User.create!(name: 'Cassius Andor', email: 'cassius@rebel.org', password: 'password') }

          run_test! do |response|
            expect(response).to have_http_status(:ok)
            expect(response.parsed_body['message']).to eq('Logged out successfully.')

            # Idempotency check: Second logout should still be fine
            delete '/api/v1/auth/logout', headers: { 'Authorization' => token_header }
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end
  end
end
