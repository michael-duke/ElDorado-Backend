class ReservationMailer < ApplicationMailer

  def confirmation_email(reservation)
    @reservation = reservation
    @user = reservation.user
    @car = reservation.car
    mail(to: @user.email, subject: "Reservation Confirmed: Your #{@car.name} is ready!")
  end
end