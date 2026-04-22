class ReservationMailerPreview < ActionMailer::Preview
  def confirmation_email
    reservation = Reservation.first || Reservation.new(
      user: User.new(name: 'Cassius Andor', email: 'cassius@rebels.com'),
      car: Car.new(name: 'Tesla Model 3', model: '2024'),
      pickup_date: Time.zone.today,
      dropoff_date: Time.zone.today + 3.days
    )

    ReservationMailer.confirmation_email(reservation)
  end
end
