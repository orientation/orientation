Orientation::Application.routes.draw do
  resources :articles

  root to: "articles#index"

  post 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
