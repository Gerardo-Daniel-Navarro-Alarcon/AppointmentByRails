# app/models/appointment.rb
class Appointment < ApplicationRecord
  # Relaciones
  belongs_to :employee
  belongs_to :service
  has_many :appointment_products, dependent: :destroy
  has_many :products, through: :appointment_products

  # Validaciones
  validates :employee_id, :service_id, :appointment_date, :status, presence: true
  validates :status, inclusion: { in: %w[pending confirmed canceled], message: "%{value} is not a valid status" }
  validate :appointment_date_cannot_be_in_the_past

  # Callbacks para manejo de inventario
  after_create :deduct_inventory, if: -> { status == 'confirmed' }
  after_destroy :restore_inventory

  # Validación personalizada para evitar fechas en el pasado
  def appointment_date_cannot_be_in_the_past
    if appointment_date.present? && appointment_date < Time.current
      errors.add(:appointment_date, "can't be in the past")
    end
  end

  private

  # Deducir inventario de productos asociados a la cita
  def deduct_inventory
    appointment_products.each do |appointment_product|
      product = appointment_product.product
      if product.stock >= appointment_product.quantity
        # Actualizar el inventario
        product.update!(stock: product.stock - appointment_product.quantity)

        # Registrar el cambio en el inventario
        InventoryLog.create!(
          product: product,
          change: -appointment_product.quantity,
          reason: 'Uso en Cita',
          appointment: self
        )

        # Alerta de inventario bajo si el stock cae por debajo del umbral
        check_low_stock_alert(product)
      else
        # Lanzar error si el inventario es insuficiente
        errors.add(:base, "Producto #{product.name} no tiene suficiente inventario")
        raise ActiveRecord::Rollback
      end
    end
  end

  # Restaurar inventario si la cita es cancelada o eliminada
  def restore_inventory
    appointment_products.each do |appointment_product|
      product = appointment_product.product
      product.update!(stock: product.stock + appointment_product.quantity)

      # Registrar la devolución de inventario
      InventoryLog.create!(
        product: product,
        change: appointment_product.quantity,
        reason: 'Cancelación de Cita',
        appointment: self
      )
    end
  end

  # Verificar si el producto tiene inventario bajo y generar alerta
  def check_low_stock_alert(product)
    low_stock_threshold = product.low_stock_threshold || 5 # Umbral de inventario bajo (definido por producto o valor predeterminado)

    if product.stock < low_stock_threshold
      # Aquí podrías enviar una notificación, loguear una alerta o ejecutar cualquier acción necesaria
      puts "Alerta: El inventario del producto '#{product.name}' está bajo. Stock actual: #{product.stock}"
      
      # Opcional: Enviar una notificación por email usando ActionMailer (requiere configurar un mailer)
      LowStockMailer.notify(product).deliver_now
    end
  end
end
