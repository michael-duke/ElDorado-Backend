class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      json_response({
        message: 'Logged in successfully.',
        data: UserSerializer.new(resource)
      }, :ok)
    else
      json_response({ message: "Login failed." }, :unauthorized)
    end
  end

  def respond_to_on_destroy
    if current_user
      json_response({ message: 'Logged out successfully.' }, :ok)
    else
      json_response({ message: 'Active session not found.' }, :unauthorized)
    end
  end
end