class Api::V1::Auth::SessionsController < Devise::SessionsController
  wrap_parameters :user, include: [:email, :password]
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      json_response({
        status: 200,
        message: 'Logged in successfully.',
        data: UserSerializer.new(resource)
      }, :ok)
    else
      json_response({
        code: 401, 
        message: "Login failed. Invalid email or password." 
        }, :unauthorized)
    end
  end

  def respond_to_on_destroy
    if current_user
      json_response({ 
        status: 200, 
        message: "Logout Successfull."
      }, :ok)
    else
      json_response({ code: 401, message: 'Active session not found.' }, :unauthorized)
    end
  end
end