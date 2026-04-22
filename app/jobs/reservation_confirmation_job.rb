class ReservationConfirmationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    Rails.logger.debug { "DEBUG: Looking for Reservation ID #{reservation_id}" }
    reservation = Reservation.find(reservation_id)
    Rails.logger.debug { "DEBUG: Found Reservation: #{reservation.inspect}" }

    ReservationMailer.confirmation_email(reservation).deliver_now
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Reservation not found: #{e.message}"
  end
end
