# config/routes.rb
Rails.application.routes.draw do
  # Rutas para los recursos principales
  resources :appointments
  resources :products
  resources :services
  resources :employees

  # Rutas para el manejo de sesiones (login, logout)
  get 'login', to: 'sessions#new', as: :login
  post 'sessions', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout

  # Ruta para la pantalla de inicio después de iniciar sesión
  get 'inicio', to: 'inicio#index', as: :inicio

  # Ruta para la página principal (root)
  root 'home#index'

  # PWA support (Progressive Web App)
  get 'service-worker', to: 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest', to: 'rails/pwa#manifest', as: :pwa_manifest

  # Health status endpoint for uptime monitoring
  get 'up', to: 'rails/health#show', as: :rails_health_check
end
