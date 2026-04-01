require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  
  # --- REGISTRATION ---
  path '/api/v1/auth/register' do
    post 'User Registration' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, 
      schema: { '$ref' => '#/components/schemas/user_registration_request'}

      response '201', 'User registered successfully' do
        schema '$ref' => '#/components/schemas/user_response'
        let(:user) { { user: { name: 'Cassius Andor', email: 'cassius@rebel.org', 
        password: 'password', password_confirmation: 'password' } } }
        run_test!
      end
      
      response '422', 'Validation Error' do
        schema '$ref' => '#/components/schemas/error'
        let(:user) { { user: { name: '', email: 'bad_email', 
        password: '1', password_confirmation: '2' } } }
        run_test!
      end
    end
  end

  # --- LOGIN ---
  path '/api/v1/auth/login' do
    post 'Sign in User' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: { '$ref' => '#/components/schemas/user_login_request'}
      response '200', 'User logged in successfully' do
        schema '$ref' => '#/components/schemas/user_response'
        let!(:existing_user) { User.create!(name: 'Cassius Andor', email: 'cassius@rebel.org',
                               password: 'password') }
        let(:credentials) { { user: { email: 'cassius@rebel.org', password: 'password' } } }
        
        after do |example|
          expect(response.headers['Authorization']).to be_present
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
      security [bearerAuth: []]
      let(:Authorization) { nil }

      response '200', 'User logged out successfully' do
        schema type: :object,
                properties:{
                status: { type: :integer, example: 200} ,
                message: { type: :string }
                }
        let(:user) { User.create!(name: 'Cassius Andor', email: 'cassius@rebel.org', 
                     password: 'password') }
        let(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }

        run_test!
      end

      response '401', 'Unauthorized - No active session' do
        schema '$ref' => '#/components/schemas/error'
        let(:Authorization) { ' ' }
        run_test!
      end
    end
  end
end