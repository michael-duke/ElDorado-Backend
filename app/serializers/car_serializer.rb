class CarSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :model, :daily_price, :description, :available
end
