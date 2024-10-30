# app/models/service.rb
class Service < ApplicationRecord
  # Validaciones
  validates :name, :description, :category, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: true

  # Scopes opcionales para filtrar servicios activos
  scope :active, -> { where(active: true) }
end
