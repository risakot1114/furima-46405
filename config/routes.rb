Rails.application.routes.draw do
  # healthチェックはそのまま残す
  get "up" => "rails/health#show", as: :rails_health_check

  # ルートをitems#indexに設定
  root "items#index"

  # items用のルーティング
  resources :items
end