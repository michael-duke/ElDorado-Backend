class CarStatusHistorySerializer < ActiveModel::Serializer
  attributes :id, :from_status, :to_status, :notes, :created_at

  attribute :user_details
  attribute :car_details

  def user_details
    if object.user
      { id: object.user.id, name: object.user.name, email: object.user.email }
    else
      { name: 'System' }
    end
  end

  def car_details
    { id: object.car.id, name: object.car.name, model: object.car.model }
  end
end
