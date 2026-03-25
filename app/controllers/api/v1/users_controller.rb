class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    json_response(current_user)
  end
end
