require 'swagger_helper'

RSpec.describe 'Api::V1::Users' do
  # rubocop:disable RSpec/VariableName
  # For Swagger UI Authorization
  let(:Authorization) { 'Bearer dummy token' }

  # rubocop:enable RSpec/VariableName
  let(:user) do
    User.create!(
      name: 'Michael',
      email: 'michael@test.com',
      password: 'password'
    )
  end

  path '/api/v1/profile' do
    get 'Show Current User Profile' do
      tags 'User Profile'
      produces 'application/json'
      security [{ bearerAuth: [] }]

      response '200', 'Profile retrieved successfully' do
        schema '$ref' => '#/components/schemas/user_response'

        before do
          sign_in user
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
