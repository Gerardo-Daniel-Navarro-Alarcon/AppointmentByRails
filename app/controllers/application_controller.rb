# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_employee!

  private

  # Método de autenticación que utiliza el token de la sesión para verificar al usuario
  def authenticate_employee!
    # Obtiene el token de la sesión
    token = session[:authentication_token]
    @current_employee = Employee.find_by(authentication_token: token)

    unless @current_employee
      # Redirige al login si no se encuentra autenticado
      redirect_to login_path, alert: 'Por favor, inicia sesión'
    end
  end

  # Permitir que otros controladores accedan al empleado autenticado
  attr_reader :current_employee
end
