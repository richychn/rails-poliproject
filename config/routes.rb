Rails.application.routes.draw do
  devise_for :users
  mount Attachinary::Engine => "/attachinary"
  root to: 'pages#home'
  resources :articles, only: [ :create ]
  resources :users, only: [ :show ] do
    resources :scans, only: [ :create ]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
