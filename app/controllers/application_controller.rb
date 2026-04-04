class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  def routing_error
    json_response({ 
      code: 404, 
      message: "No route matches [#{request.method}] \"#{request.path}\"" 
    }, :not_found)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end
end
