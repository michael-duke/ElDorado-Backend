require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users/' do
    get 'Show Current User' do
      tags 'Current User'
      produces 'application/json'

      response '200', 'Current User found' do
        before do
          @user = User.create(name: 'Michael Mesfin', email: 'michael@jedi.com', password: 'password',
                              password_confirmation: 'password')
          sign_in @user
        end

        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string }
               },
               required: %w[id name email]
        run_test!
      end

      response '401', 'You must Login or Register. Current user not found' do
        let(:user) { 'invalid' }
        run_test!
      end
    end
  end
end
