class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    if current_user
      json_response({
                      status: 200,
                      message: 'Profile retrieved successfully.',
                      data: UserSerializer.new(current_user)
                    })
    else
      json_response({
                      status: 401,
                      message: 'Unauthorized. You must login to access this page.'
                    }, :unauthorized)
    end
  end
end
