Rails.application.routes.draw do
  devise_for :users
  get 'items/index'

  get "up" => "rails/health#show", as: :rails_health_check

  root "items#index"
  resources :items

   # ユーザー詳細ページのルーティング（ヘッダー用）
  resources :users, only: [:show]
  
end