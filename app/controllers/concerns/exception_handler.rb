module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ code: 404, message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ code: 422, message: e.message }, :unprocessable_entity)
    end
    
    rescue_from AASM::InvalidTransition do |e|
      json_response({ 
        code: 422, 
        message: "State transition invalid: This car cannot be reserved in its current status." 
      }, :unprocessable_entity)
    end
  end
end
