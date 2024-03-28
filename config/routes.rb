Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  get '/current_user' => 'current_user#index'

  namespace :api do
    namespace :v1 do
      resources :categories, only: [:create, :index, :update, :destroy]
      resources :transactions, only: [:show, :update, :destroy]
      resources :incomes, only: [:create, :index, :update, :destroy]
      resources :goals, only: [:create, :index, :show, :update, :destroy]

      resources :categories do
        resources :transactions, only: [:index, :create]
      end
    end
  end
  # get "up" => "rails/health#show", as: :rails_health_check
end
