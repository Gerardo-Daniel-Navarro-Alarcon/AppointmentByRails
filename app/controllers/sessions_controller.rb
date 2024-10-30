# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  # Método para mostrar el formulario de inicio de sesión
  def new
  end

  # Método para manejar el inicio de sesión
  def create
    uri = URI.parse('http://localhost:3001/auth/login')  # Verifica esta URL
    response = Net::HTTP.post_form(uri, {
      email: params[:email],
      password: params[:password]
    })

    if response.is_a?(Net::HTTPSuccess)
      redirect_to inicio_path, notice: 'Inicio de sesión exitoso'
    else
      flash.now[:alert] = 'Correo o contraseña incorrectos'
      render :new
    end
  end

  # Método para cerrar sesión
  def destroy
    uri = URI.parse('http://localhost:3001/auth/logout')
    Net::HTTP.post(uri, {})
    redirect_to login_path, notice: 'Sesión cerrada correctamente'
  end
end
