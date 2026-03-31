class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation]
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    json_response({
      status: 201,
      message: 'Signed up sucessfully.',
      data: UserSerializer.new(current_user)
    },:created)
  end

  def register_failed
      json_response({
      code: 422,
      message: "Registration failed. #{resource.errors.full_messages.to_sentence}"
    },:unprocessable_entity)
  end
end
