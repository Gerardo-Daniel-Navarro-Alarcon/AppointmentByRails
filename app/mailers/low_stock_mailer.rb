class LowStockMailer < ApplicationMailer
  def notify(product)
    @product = product
    mail(to: "on04724@gmail.com", subject: "Alerta de Inventario Bajo: #{product.name}")
  end
end
