class ReservationConfirmationJob
  include Sidekiq::Job

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    
    ReservationMailer.confirmation_email(reservation).deliver_now
  rescue ActiveRecord::RecordNotFound
    # If the reservation was deleted before the job ran, just skip it
    true
  end
end