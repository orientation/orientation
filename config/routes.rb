Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :tags

  resources :authors, only: [:index, :show, :update]
  resources :articles do
  	put :make_fresh, on: :member
  end
  resources :articles, path: "", only: :show

  root "articles#index"
end
