# app/models/appointment.rb
class Appointment < ApplicationRecord
  # Relaciones
  belongs_to :employee
  belongs_to :service

  # Validaciones
  validates :employee_id, :service_id, :appointment_date, :status, presence: true
  validates :status, inclusion: { in: %w[pending confirmed canceled], message: "%{value} is not a valid status" }
  validate :appointment_date_cannot_be_in_the_past

  # Validación personalizada para evitar fechas en el pasado
  def appointment_date_cannot_be_in_the_past
    if appointment_date.present? && appointment_date < Time.current
      errors.add(:appointment_date, "can't be in the past")
    end
  end
end
