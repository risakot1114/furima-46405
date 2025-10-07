Rails.application.routes.draw do

  devise_for :users
 
  get "up" => "rails/health#show", as: :rails_health_check

  root "items#index"

  resources :items do
  resources :orders, only: [:new, :create]
  end

  resources :users, only: [:show]
  
end