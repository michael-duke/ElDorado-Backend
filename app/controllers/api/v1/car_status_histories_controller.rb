class Api::V1::CarStatusHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @histories = CarStatusHistory.includes(:user, :car).all
    render json: @histories, status :ok
  end

  private

  def ensure_admin!
    unless current_user.admin?
      render json: { error: "Unauthorized access. Admins only." }, status: :forbidden
    end
  end
end