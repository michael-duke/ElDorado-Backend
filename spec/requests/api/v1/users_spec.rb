require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  # For Swagger UI Authorization
  let(:Authorization) { 'Bearer dummy token' }

  path '/api/v1/profile' do
    get 'Show Current User Profile' do
      tags 'User Profile'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response '200', 'Profile retrieved successfully' do
        schema '$ref' => '#/components/schemas/user_response'

        before do
          @user = User.create!(
            name: 'Michael',
            email: 'michael@test.com',
            password: 'password'
          )
          sign_in @user
        end

        run_test!
      end

      response '401', 'Unauthorized - Please login' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }
        run_test!
      end
    end
  end
end
