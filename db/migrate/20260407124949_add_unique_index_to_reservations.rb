class AddUniqueIndexToReservations < ActiveRecord::Migration[7.1]
  def change
    add_index :reservations, [:car_id, :user_id], unique: true
  end
end
