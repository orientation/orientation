Orientation::Application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :tags

  resources :articles, except: :show
  resources :articles, path: "", only: :show

  root to: "articles#index"
end
