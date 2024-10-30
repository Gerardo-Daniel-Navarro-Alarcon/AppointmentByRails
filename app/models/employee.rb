# app/models/employee.rb
class Employee < ApplicationRecord
  # Validaciones
  validates :first_name, :last_name, :email, :role, presence: true
  validates :email, uniqueness: true
  validates :phone_number, length: { is: 10 }, allow_blank: true
end