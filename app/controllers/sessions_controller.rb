# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_employee!, only: [:new, :create]

  def new
    # Renderiza el formulario de inicio de sesión
  end

  def create
    employee = Employee.find_by(email: params[:email])

    if employee&.authenticate(params[:password])
      # Genera el token si no existe
      employee.update(authentication_token: SecureRandom.hex) unless employee.authentication_token

      # Guarda el token en la sesión
      session[:authentication_token] = employee.authentication_token

      # Redirige a la pantalla de inicio
      redirect_to inicio_path, notice: 'Inicio de sesión exitoso'
    else
      # Renderiza el formulario con un mensaje de error
      flash.now[:alert] = 'Credenciales inválidas'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Elimina el token y cierra la sesión
    if current_employee
      current_employee.update(authentication_token: nil)
      session[:authentication_token] = nil
      redirect_to login_path, notice: 'Sesión cerrada'
    else
      redirect_to login_path, alert: 'No hay ninguna sesión activa'
    end
  end
end
