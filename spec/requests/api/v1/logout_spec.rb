require 'swagger_helper'

RSpec.describe 'api/v1/logout', type: :request do
  path '/api/v1/logout' do
    delete 'Sign out User' do
      tags 'Logout'
      consumes 'application/json'
      parameter name: :Authorization, in: :header, type: :string,
                description: 'Authorization JWT Token (Check Response Headers in login or register)'
      response '200', 'Logged out successfull' do
        before do
          @user = User.create(name: 'Aamir', email: 'aamir@jedi.com', password: 'password',
                              password_confirmation: 'password')
          def encode(payload, exp = 120.minutes.from_now)
            payload[:exp] = exp.to_i
            "Bearer #{JWT.encode(payload, ENV.fetch('DEVISE_JWT_SECRET_KEY', nil))}"
          end
          @token = encode({ sub: @user.id, jti: @user.jti, scp: 'user' })
          sign_in @user
        end

        let(:Authorization) { @token }
        run_test!
      end

      response '401', 'Authorization token is invalid' do
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
