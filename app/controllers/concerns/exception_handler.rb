module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # 404: Not Found
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ code: 404, message: "Resource not found." }, :not_found)
    end

    # 422: Validation or State Machine errors
    rescue_from ActiveRecord::RecordInvalid, AASM::InvalidTransition do |e|
      json_response({ code: 422, message: e.message }, :unprocessable_entity)
    end

    # 401: JWT / Auth Failures
    rescue_from JWT::DecodeError, JWT::ExpiredSignature do |e|
      json_response({ code: 401, message: "Session invalid or expired. Please login." }, :unauthorized)
    end
    
    # 400: Bad Request / Missing Parameters
    rescue_from ActionController::ParameterMissing do |e|
      json_response({ 
        code: 400, 
        message: "Bad Request: Missing parameter '#{e.param}' (Expected nested 'user' object)" 
      }, :bad_request)
    end
    
    # 403: Forbidden
    def forbidden_error(msg = "Forbidden: Admin access required.")
      json_response({ code: 403, message: msg }, :forbidden)
    end
  end
end