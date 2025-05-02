Rails.application.routes.draw do
  devise_for :users
  root to: "pairs#index"

  resources :pairs, only: [:index, :new, :create ]



  
end
