Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  get '/current_user' => 'current_user#index'

  # get "up" => "rails/health#show", as: :rails_health_check
end
