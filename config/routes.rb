Orientation::Application.routes.draw do
  resources :articles, path: "", only: :show
  resources :articles, except: :show
  resources :tags

  get '*id', to: 'articles#show'

  root to: "articles#index"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
