class AppointmentProduct < ApplicationRecord
  belongs_to :appointment
  belongs_to :product
end
