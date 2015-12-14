Rails.application.routes.draw do
  devise_for :admins
  root 'static#fetch'
  get 'dashboard', to: 'dashboard#admin', as: 'admin_dashboard'
  resources :access_keys, except: [:show]
  post 'authorize', to: 'access_keys#authorize', as: 'authorize_access_key'
  patch 'pages/:page_id/toggle', to: 'pages#toggle_visibility', as: 'toggle_page_visibility'
  get '*request', to: 'static#fetch'
end
