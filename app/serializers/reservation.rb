class ReservationSerializer < ActiveModel::Serializer
  belongs_to :car
  attributes :id, :pickup_date, :dropoff_date
end
