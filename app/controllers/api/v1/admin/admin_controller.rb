class Api::V1::Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  private

  def authorize_admin!
    return if current_user.admin?

    json_response({ code: 403, message: 'Forbidden: Admin access required.' }, :forbidden)
  end
end
