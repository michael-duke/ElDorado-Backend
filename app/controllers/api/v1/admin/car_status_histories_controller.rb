class Api::V1::Admin::CarStatusHistoriesController < Api::V1::Admin::AdminController
  include ResourceFindable
  before_action :set_resource

  def index
    @histories = @car.car_status_histories.includes(:user).order(created_at: :desc)
    
    history_data = @histories.map  {|h| CarStatusHistorySerializer.new(h).serializable_hash }

    json_response({ 
      status: 200, 
      message: 'Car history retrieved successfully.', 
      data: history_data },:ok)
  end
end